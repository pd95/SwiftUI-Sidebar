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
                ItemView(item: item)
            }
            else {
                Text("Select an item")
                    .navigationTitle("")
            }
        }
        .onAppear() {
            print("onAppear: SupplementalView")
        }
    }
}

struct ItemView: View {
    let item: Item
    
    var body: some View {
        VStack {
            Text("Some information about \(item.name)")
            Spacer()
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
