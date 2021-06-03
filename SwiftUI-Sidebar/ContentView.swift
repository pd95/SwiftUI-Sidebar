//
//  ContentView.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 16.05.21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var store = ItemStore()
    
    @AppStorage("selectedCategory") private var selectedCategory: String?
    @AppStorage("selectedItem") private var selectedItem: String?

    var body: some View {
        NavigationView {

            if horizontalSizeClass == .compact {
                // single column mode
                SidebarList()
            }
            else {
                // three column mode
                SidebarList()

                PrimaryView()
                    .onAppear(perform: {
                        print("1️⃣ PrimaryView on screen")
                    })
                    .onDisappear(perform: {
                        print("1️⃣ PrimaryView off screen")
                    })

                SupplementalView()
                    .onAppear(perform: {
                        print("2️⃣ SupplementalView on screen")
                    })
                    .onDisappear(perform: {
                        print("2️⃣ SupplementalView off screen")
                    })
            }
            
        }
        .environmentObject(store)
        //.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .onAppear() {
            print("onAppear: ContentView AppStorage State:")
            print(">  selectedCategory = \(selectedCategory)")
            print(">  selectedItem = \(selectedItem)")
        }
        .onChange(of: selectedCategory, perform: { value in
            print(">  selectedCategory = \(selectedCategory) >> \(value)")
        })
        .onChange(of: selectedItem, perform: { value in
            print(">  selectedItem = \(selectedItem) >> \(value)")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1195, height: 700))
    }
}
