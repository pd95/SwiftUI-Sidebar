//
//  SwiftUI_SidebarApp.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 16.05.21.
//

import SwiftUI

@main
struct SwiftUI_SidebarApp: App {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some Scene {
        WindowGroup {
            ContentView(isCompact: horizontalSizeClass == .compact)
        }
    }
}
