//
//  PrimaryView.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct PrimaryView: View {
    @EnvironmentObject var store: ItemStore
    
    @AppStorage("selectedCategory") private var selectedCategory: String?

    var body: some View {
        Group {
            if let category = selectedCategory{
                CategoryView(category: category)
            }
            else {
                Text("Select a category")
            }
        }
        .onAppear() {
            print("onAppear: PrimaryView 1️⃣ AppStorage State:")
            print(">  selectedCategory = \(selectedCategory)")
        }
        .onDisappear() {
            print("onDisappear: PrimaryView 1️⃣")
        }
    }
}


struct CategoryView: View {
    @EnvironmentObject var store: ItemStore
    let category: String
    
    @AppStorage("selectedItem") private var selectedItem: String?
    @State private var activatedNavigationLink: String?
    
    var body: some View {
        VStack {
            List {
                ForEach(store.items(for: category)) { item in
                    if store.screenIsCompact {
                        // Intead of this nice and simple NavigationLink:
                        NavigationLink(
                            destination: ItemView(item: item),
                            tag: item.name,
                            selection: $selectedItem
                        ) {
                            Text(item.name)
                        }
                    }
                    else {
                        // We have to use something completely custom:
                        let isSelected = selectedItem == item.name
                        Button(action: { selectItem(item) }) {
                            Text(item.name)
                                .foregroundColor(isSelected ? Styling.selectionForegroundColor : .primary)
                                .padding(.leading, OperatingSystem.current == .macOS ? 8 : 0)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                        // Use PlainButtonStyle: with the least disturbing UI effects when pressed
                        .buttonStyle(PlainButtonStyle())

                        // Use custom row background to handle selection incl. NavigationLink
                        .listRowBackground(rowBackground(for: item, isSelected: isSelected))
                    }
                }
            }
            .listStyle(InsetListStyle())
            .onAppear() {
                print("onAppear: CategoryView List ----------------------------")
                // Restore previous selection
                if !store.screenIsCompact {
                    if let selectedItem = selectedItem {
                        print("  navigating to \(selectedItem)")
                        activatedNavigationLink = selectedItem
                    }
                }
            }
        }

        // Propagate change of selection to navigation link
        .onChange(of: selectedItem, perform: { value in
            print("selectedItem = \(value)")
            if value != activatedNavigationLink {
                activatedNavigationLink = value
            }
        })
        // Propagate change on navigation link to selection
        .onChange(of: activatedNavigationLink, perform: { value in
            print("activatedNavigationLink = \(value)")
            if let newValue = value, newValue != selectedItem {
                selectedItem = newValue
            }
        })
        .onAppear() {
            print("onAppear: CategoryView AppStorage State:")
            print(">  selectedItem = \(selectedItem)")
        }
        .navigationTitle(category)
    }
    
    func rowBackground(for item: Item, isSelected: Bool) -> some View {
        ZStack {
            Color.clear
            if isSelected {
                RoundedRectangle(cornerRadius: Styling.selectionRectangleRadius)
                    .foregroundColor(.accentColor)
            }
        }
        .onTapGesture(perform: { selectItem(item) })
        .background(Group {
            #if os(iOS)
            NavigationLink(
                destination: ItemView(item: item),
                tag: item.name,
                selection: $activatedNavigationLink,
                label: {
                    EmptyView()
                }
            )
            #endif
        })
    }
    
    private func selectItem(_ item: Item) {
        selectedItem = item.name
    }
}


struct PrimaryView_Previews: PreviewProvider {
    @AppStorage("selectedCategory") static private var selectedCategory: String?
    @AppStorage("selectedItem") static private var selectedItem: String?

    static let store: ItemStore = {
        let store = ItemStore()
        return store
    }()
    static var previews: some View {
        NavigationView {
            PrimaryView()
        }
        .environmentObject(store)
        .onAppear() {
            selectedCategory = "Games"
            selectedItem = "Game 3"
        }
        //.navigationViewStyle(StackNavigationViewStyle())
        .previewLayout(.fixed(width: 500, height: 700))
    }
}
