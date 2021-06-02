//
//  SupplementalView.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct SupplementalView: View {
    @ObservedObject var store: ItemStore
    
    var body: some View {
        Group {
            if let item = store.selectedItem {
                ItemView(store: store, item: item)
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
    @ObservedObject var store: ItemStore
    let item: Item
    
    var body: some View {
        VStack {
            Text("Some information about \(item.name)")
            Spacer()
        }
        .onAppear() {
            print("onAppear: ItemView \(item.name)")
            store.selectItem(item)
        }
        .onDisappear() {
            print("onDisappear: ItemView \(item.name)")
        }
        .navigationTitle("\(item.name)")
    }
}


struct SupplementalView_Previews: PreviewProvider {
    static let store: ItemStore = {
        let store = ItemStore()
        store.selectCategory("Games")
        store.selectItem("Game 3")
        return store
    }()
    static var previews: some View {
        NavigationView {
            Text("Master")
            SupplementalView(store: store)
        }
    }
}
