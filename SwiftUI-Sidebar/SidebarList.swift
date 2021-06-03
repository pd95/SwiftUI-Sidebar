//
//  SidebarList.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct SidebarList: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var store: ItemStore
    
    @AppStorage("selectedCategory") private var selectedCategory: String?
    @State private var activatedNavigationLink: String?

    var body: some View {
        List {
            ForEach(store.categories, id: \.self) { category in
                if horizontalSizeClass == .compact {
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
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Label(category, systemImage: store.symbolName(for: category))
                            //.foregroundColor(isSelected ? Color(.secondarysystemBackground) : .primary)
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
            activatedNavigationLink = selectedCategory
        })
        .navigationTitle("Categories")
    }

    func rowBackground(for category: String, isSelected: Bool) -> some View {
        ZStack {
            // Background color for sidebar style:
            Color(.secondarySystemBackground)
            if isSelected {
                RoundedRectangle(cornerRadius: 12.0)
                    .foregroundColor(Color(.secondarySystemFill))
            }
        }
        .background(
            NavigationLink(
                destination: CategoryView(category: category),
                tag: category,
                selection: $activatedNavigationLink,
                label: {
                    EmptyView()
                }
            )
        )
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
