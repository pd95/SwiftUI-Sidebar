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
                SidebarRow(category: category,
                           symbolName: store.symbolName(for: category),
                           isSelected: store.selectedCategory == category) {
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
        let symbolName: String
        let isSelected: Bool
        let tapAction: () -> Void
        
        var body: some View {
            Label(category, systemImage: symbolName)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture(perform: tapAction)
                .listRowBackground(rowBackground)
        }
        
        var rowBackground: some View {
            ZStack {
                Color(.secondarySystemBackground)
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemFill))
                }
            }
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
