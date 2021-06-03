//
//  SupplementalView.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct SupplementalView: View {
    @EnvironmentObject var store: ItemStore

    @AppStorage("selectedItem") private var selectedItem: String?

    var body: some View {
        Group {
            if let selectedItem = selectedItem,
               let item = store.item(named: selectedItem)
            {
                ItemView(item: item)
            }
            else {
                Text("Select an item")
                    .navigationTitle("")
            }
        }
        .onAppear() {
            print("onAppear: SupplementalView 2️⃣")
        }
        .onDisappear() {
            print("onDisappear: SupplementalView 2️⃣")
        }
    }
}

struct ItemView: View {
    @EnvironmentObject var store: ItemStore
    let item: Item
    
    var body: some View {
        VStack {
            Text("Some information about \(item.name)")
            Spacer()
        }
        .onAppear() {
            print("onAppear: ItemView \(item.name)")
        }
        .onDisappear() {
            print("onDisappear: ItemView \(item.name)")
        }
        .navigationTitle("\(item.name)")
    }
}


struct SupplementalView_Previews: PreviewProvider {
    @AppStorage("selectedCategory") static private var selectedCategory: String?
    @AppStorage("selectedItem") static private var selectedItem: String?

    static let store: ItemStore = {
        let store = ItemStore()
        return store
    }()
    static var previews: some View {
        NavigationView {
            Text("Master")
            SupplementalView()
        }
        .environmentObject(store)
        .onAppear() {
            selectedCategory = "Games"
            selectedItem = "Game 3"
        }
    }
}
