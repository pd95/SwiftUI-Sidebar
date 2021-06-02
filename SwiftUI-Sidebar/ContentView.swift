//
//  ContentView.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 16.05.21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var store = ItemStore()

    // BUG: AppStorage does not support Optional types therefore it cannot be used to remember list selection?!
    @AppStorage("selectedCategory") private var selectedCategory: String = ""
    @AppStorage("selectedItem") private var selectedItem: String = ""
        
    var body: some View {
        NavigationView {
            SidebarList(store: store)

            PrimaryView(store: store)
            
            SupplementalView(store: store)
        }
        //.navigationViewStyle(DoubleColumnNavigationViewStyle())
        
        // Here we synchronize our model state with AppStorage ==> Better use UserDefaults in the first place?!
        .onChange(of: store.selectedCategory, perform: { newSelection in
            print("AppStorage sync: new selectedCategory = \(newSelection ?? "-")")
            if let newSelection = newSelection {
                selectedCategory = newSelection
            }
        })
        .onChange(of: store.selectedItem, perform: { newSelection in
            print("AppStorage sync: new selectedItem = \(newSelection?.name ?? "-")")
            if let newSelection = newSelection {
                selectedItem = newSelection.name
            }
        })
        // Sync AppStorage values with model data
        .onAppear() {
            print("onAppear: NavigationView restoring AppStorage")
            store.selectCategory(selectedCategory)
            store.selectItem(selectedItem)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1195, height: 700))
    }
}
