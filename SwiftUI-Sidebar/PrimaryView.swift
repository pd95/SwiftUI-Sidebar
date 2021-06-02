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
            print("onAppear: PrimaryView")
        }
    }
}


struct CategoryView: View {
    @ObservedObject var store: ItemStore

    let category: String
    
    var body: some View {
        VStack {
            List {
                ForEach(store.items(for: category)) { item in
                    CategoryRow(item: item, isSelected: store.selectedItem == item) {
                        store.selectItem(withID: item.id)
                    }
                }
            }
        }
        .onAppear() {
            print("onAppear: \(category) ----------------------------")
        }
        .onDisappear() {
            print("onDisappear: \(category) ----------------------------")
        }
        .navigationBarTitle(category)
    }

    struct CategoryRow: View {
        let item: Item
        let isSelected: Bool
        let tapAction: () -> Void
        
        var body: some View {
            Text(item.name)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture(perform: tapAction)
                .listRowBackground(rowBackground)
                .overlay(selectionChevron, alignment: .trailing)
                .foregroundColor(isSelected ? .white : .primary)
        }

        @ViewBuilder
        var rowBackground: some View {
            if isSelected {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor)
            }
        }
        
        @ViewBuilder
        var selectionChevron: some View {
            if isSelected {
                Image(systemName: "chevron.right")
            }
        }
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
    }
}
