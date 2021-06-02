//
//  PrimaryView.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct PrimaryView: View {
    @ObservedObject var store: ItemStore
    
    var body: some View {
        Group {
            if let category = store.selectedCategory {
                CategoryView(store: store, category: category)
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
    @ObservedObject var store: ItemStore
    let category: String
    
    @State private var firstAppear = true
    @State private var selectedItemLink: Item?
    var body: some View {
        VStack {
            List {
                ForEach(store.items(for: category)) { item in
//                    let isSelected = selectedItemLink == item || store.selectedItem == item
                    NavigationLink(
                        destination: ItemView(store: store, item: item),
                        tag: item,
                        selection: $selectedItemLink
                    ) {
                        Text(item.name)
//                            .foregroundColor(isSelected ? Color(.systemBackground) : .primary)
                    }
//                    .listRowBackground(
//                        ZStack {
//                            Color.white
//                            if isSelected {
//                                RoundedRectangle(cornerRadius: 8.0)
//                                    .foregroundColor(.accentColor)
//                            }
//                        }
//                    )
                }
            }
            .listStyle(InsetListStyle())
            .onAppear() {
                print("onAppear: CategoryView List ----------------------------")
            }
        }
        .onAppear() {
            print("onAppear: CategoryView \(category) ----------------------------")
            print("selectedItemLink = \(selectedItemLink)")
            store.selectCategory(category)
        }
        .onDisappear() {
            print("onDisappear: CategoryView \(category) ----------------------------")
            print("selectedItemLink = \(selectedItemLink)")
        }
        .onChange(of: selectedItemLink, perform: { value in
            print("selectedItemLink = \(value)")
        })
        .navigationBarTitle(category)
    }
}


struct PrimaryView_Previews: PreviewProvider {
    static let store: ItemStore = {
        let store = ItemStore()
        store.selectCategory("Games")
        store.selectItem("Game 3")
        return store
    }()
    static var previews: some View {
        NavigationView {
            PrimaryView(store: store)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .previewLayout(.fixed(width: 500, height: 700))
    }
}
