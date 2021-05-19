//
//  SidebarList.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI


struct SidebarList: View {
    @ObservedObject var store: ItemStore
    
    var body: some View {
        List {
            ForEach(store.categories, id: \.self) { category in
                SidebarRow(category: category, isSelected: store.selectedCategory == category) {
                    store.selectCategory(category)
                }
            }
        }
        .listStyle(SidebarListStyle())
        .onAppear() {
            print("onAppear: sidebar list")
        }
    }


    struct SidebarRow: View {
        let category: String
        let isSelected: Bool
        let tapAction: () -> Void
        
        var body: some View {
            Text(category)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture(perform: tapAction)
                // iOS BUG: Cannot modify background of Sidebar list row without breaking it
                //.listRowBackground(SelectedListItemBackground(isSelected: isSelected))
                //.foregroundColor(isSelected ? .white : .primary)
                .overlay(SelectedListItemOverlay(isSelected: isSelected), alignment: .trailing)
        }
    }
}


struct SidebarList_Previews: PreviewProvider {
    static let store: ItemStore = {
        let store = ItemStore()
        store.selectCategory("Games")
        store.selectItem("Game 3")
        return store
    }()
    static var previews: some View {
        NavigationView {
            SidebarList(store: store)
            Text("Primary view")
        }
        .previewLayout(.fixed(width: 1024, height: 768))
        //.navigationViewStyle(StackNavigationViewStyle())
    }
}
