//
//  Model.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import Foundation

enum ItemType: String, Hashable, CaseIterable {
    case book = "Books", video = "Videos", game = "Games", various = "Various"
    case undefined = "Undefined"
    
    var name: String {
        String(describing: self).capitalized
    }

    var pluralName: String {
        self.rawValue
    }
}

struct Item: Identifiable, Hashable{
    let id = UUID()

    let type: ItemType
    let name: String
}

class ItemStore: ObservableObject {
    
    @Published private(set) var allItems: [ItemType: [Item]]
   
    @Published private(set) var selectedCategory: String?
    @Published private(set) var selectedItem: Item?

    init() {
        allItems = [
            .book:    (1...7).map { Item(type: .book, name: "Book \($0)") },
            .video:   (1...3).map { Item(type: .video, name: "Video \($0)") },
            .game:    (1...10).map { Item(type: .game, name: "Game \($0)") },
            .various: (1...5).map { Item(type: .various, name: "Stuff \($0)") },
        ]
    }
    
    var categories: [String] {
        ItemType.allCases.map(\.rawValue)
    }
    
    func symbolName(for category: String) -> String {
        let itemType = ItemType(rawValue: category) ?? .undefined
        switch itemType {
        case .book:
            return "books.vertical"
        case .video:
            return "film"
        case .game:
            return "gamecontroller"
        case .various:
            return "rectangle.stack"
        case .undefined:
            return "questionmark.circle"
        }
    }

    func items(for category: String) -> [Item] {
        let itemType = ItemType(rawValue: category) ?? .undefined
        return allItems[itemType, default: []]
    }
    
    func selectCategory(_ name: String) {
        print("selecting category: \(name)")
        if selectedCategory != name {
            print("removing selected item: \(selectedItem)")
            selectedItem = nil
            selectedCategory = name
        }
    }

    func selectItem(_ item: Item?) {
        print("selecting item: \(item?.id)")
        if selectedItem != item {
            selectedItem = item
        }
    }
    
    func selectItem(_ name: String) {
        print("selecting item: \(name)")
        let newItem = items(for: selectedCategory ?? "").first(where: { $0.name == name })
        if newItem != selectedItem {
            selectedItem = newItem
        }
    }
}
