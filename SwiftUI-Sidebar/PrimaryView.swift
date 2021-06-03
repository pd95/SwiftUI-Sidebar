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
            print("onAppear: PrimaryView 1️⃣")
        }
        .onDisappear() {
            print("onDisappear: PrimaryView 1️⃣")
        }
    }
}


struct CategoryView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var store: ItemStore
    let category: String
    
    @AppStorage("selectedItem") private var selectedItem: String?
    @State private var activatedNavigationLink: String?
    
    var body: some View {
        VStack {
            List {
                ForEach(store.items(for: category)) { item in
                
                    if horizontalSizeClass == .compact {
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
                        Button(action: {
                            selectedItem = item.name
                        }) {
                            Text(item.name)
                                .foregroundColor(isSelected ? Color(.systemBackground) : .primary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                        // Use PlainButtonStyle: with the least disturbing UI effects when pressed
                        .buttonStyle(PlainButtonStyle())

                        .listRowBackground(
                            ZStack {
                                Color(.systemBackground)
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 12.0)
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .background(navigationLink(for: item))
                        )
                    }
                }
            }
            .listStyle(InsetListStyle())
            .onAppear() {
                print("onAppear: CategoryView List ----------------------------")
                // Restore previous selection
                if horizontalSizeClass == .regular {
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
        .navigationBarTitle(category)
    }
    
    func navigationLink(for item: Item) -> some View {
        NavigationLink(
            destination: ItemView(item: item),
            tag: item.name,
            selection: $activatedNavigationLink,
            label: {
                EmptyView()
            }
        )
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
        .navigationViewStyle(StackNavigationViewStyle())
        .previewLayout(.fixed(width: 500, height: 700))
    }
}
