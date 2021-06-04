//
//  SidebarList.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct SidebarList: View {
    @EnvironmentObject var store: ItemStore
    
    @AppStorage("selectedCategory") private var selectedCategory: String?
    @State private var activatedNavigationLink: String?

    var body: some View {
        List {
            ForEach(store.categories, id: \.self) { category in
                if store.screenIsCompact {
                    // Intead of this nice and simple NavigationLink:
                    NavigationLink(
                        destination: CategoryView(category: category),
                        tag: category,
                        selection: $selectedCategory
                    ) {
                        Label(category, systemImage: store.symbolName(for: category))
                    }
                }
                else {
                    // We have to use something completely custom:
                    let isSelected = selectedCategory == category
                    Button(action: { selectCategory(category) }) {
                        Label(category, systemImage: store.symbolName(for: category))
                            //.foregroundColor(isSelected ? Styling.sidebarSelectionForegroundColor : .primary)
                            .padding(.leading, OperatingSystem.current == .macOS ? 8 : 0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    // Use PlainButtonStyle: with the least disturbing UI effects when pressed
                    .buttonStyle(PlainButtonStyle())
                    
                    // Use custom row background to handle selection incl. NavigationLink
                    .listRowBackground(rowBackground(for: category, isSelected: isSelected))
                }
            }
        }
        .listStyle(SidebarListStyle())
        
        // Propagate change of selection to navigation link
        .onChange(of: selectedCategory, perform: { value in
            print("SidebarList>  selectedCategory = \(selectedCategory) >> \(value)")
            activatedNavigationLink = selectedCategory
        })
        .navigationTitle("Categories")
    }
    
    func rowBackground(for category: String, isSelected: Bool) -> some View {
        ZStack {
            // Background color for sidebar style:
            Styling.sidebarListBackgroundColor
            if isSelected {
                RoundedRectangle(cornerRadius: Styling.selectionRectangleRadius)
                    .foregroundColor(Styling.sidebarSelectionBackgroundColor)
            }
        }
        .onTapGesture(perform: { selectCategory(category) })
        .background(Group {
            #if os(iOS)
            NavigationLink(
                destination: CategoryView(category: category),
                tag: category,
                selection: $activatedNavigationLink,
                label: {
                    EmptyView()
                }
            )
            #endif
        })
    }

    private func selectCategory(_ category: String) {
        selectedCategory = category
    }
}


struct SidebarList_Previews: PreviewProvider {
    @AppStorage("selectedCategory") static var selectedCategory: String?
    @AppStorage("selectedItem")     static var selectedItem: String?

    static let store: ItemStore = {
        let store = ItemStore()
        return store
    }()
    static var previews: some View {
        NavigationView {
            SidebarList()
            Text("Primary view")
        }
        .environmentObject(store)
        .onAppear() {
            selectedCategory = "Games"
            selectedItem = "Game 3"
        }
        .previewLayout(.fixed(width: 1195, height: 700))
    }
}
