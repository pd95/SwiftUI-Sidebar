//
//  Model.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import Foundation

struct Item: Identifiable, Hashable{
    let id = UUID()

    enum ItemType {
        case book, video, game, various
    }
    
    let type: ItemType
    let name: String
}

class ItemStore: ObservableObject {
    @Published var allCategories: [String]
    @Published var allItems: [String: [Item]]
   
    @Published var selectedCategory: String?
    @Published var selectedItem: Item?

    init() {
        let categorizedItems = [
            "Books": (1...7).map { Item(type: .book, name: "Book \($0)") },
            "Videos": (1...3).map { Item(type: .video, name: "Video \($0)") },
            "Games": (1...10).map { Item(type: .game, name: "Game \($0)") },
            "Various": (1...5).map { Item(type: .various, name: "Stuff \($0)") },
        ]
        allItems = categorizedItems
        allCategories = Array(categorizedItems.keys).sorted()
    }
    
    var categories: [String] {
        allCategories
    }

    func items(for category: String) -> [Item] {
        allItems[category, default: []]
    }
    
    func selectCategory(_ name: String) {
        print("selecting category: \(name)")
        if selectedCategory != name {
            print("removing selected item: \(selectedItem)")
            selectedItem = nil
        }
        selectedCategory = name
    }

    func selectItem(withID id: Item.ID) {
        print("selecting item: \(id)")
        selectedItem = items(for: selectedCategory ?? "").first(where: { $0.id == id })
    }
    
    func selectItem(_ name: String) {
        print("selecting item: \(name)")
        selectedItem = items(for: selectedCategory ?? "").first(where: { $0.name == name })
    }
}
