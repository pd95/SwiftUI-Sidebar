//
//  SidebarList.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI


struct SidebarList: View {
    @ObservedObject var store: ItemStore
    
    @State private var isNew = true
    @State private var selectedCategoryLink: String?
    
    var body: some View {
        List {
            ForEach(store.categories, id: \.self) { category in
                NavigationLink(
                    destination: CategoryView(store: store, category: category),
                    tag: category,
                    selection: $selectedCategoryLink
                ) {
                    Label(category, systemImage: store.symbolName(for: category))
                }
            }
        }
        .listStyle(SidebarListStyle())
        .onAppear() {
            print("onAppear: SidebarList ----------------------------")
            print("selectedCategoryLink = \(selectedCategoryLink)")
        }
        .onDisappear() {
            print("onDisappear: SidebarList ----------------------------")
            print("selectedCategoryLink = \(selectedCategoryLink)")
        }
        .onChange(of: selectedCategoryLink, perform: { value in
            print("selectedCategoryLink = \(value)")
        })
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
        .previewLayout(.fixed(width: 1195, height: 700))
        //.navigationViewStyle(StackNavigationViewStyle())
    }
}
