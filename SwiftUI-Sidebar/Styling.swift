//
//  Styling.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 04.06.21.
//

import SwiftUI

// Colors to style the CategoryView's List
enum Styling {
    #if os(macOS)
    static let selectionRectangleRadius: CGFloat = 4

    static let selectionForegroundColor = Color(.controlBackgroundColor)
    static let selectionBackgroundColor = Color.accentColor

    static let sidebarSelectionForegroundColor = Color.primary
    static let sidebarSelectionBackgroundColor = Color(.separatorColor)

    #else
    static let selectionRectangleRadius: CGFloat = 12

    static let selectionForegroundColor = Color(.secondarySystemBackground)
    static let selectionBackgroundColor = Color(.systemBackground)
    
    static let sidebarSelectionForegroundColor = Color.primary
    static let sidebarSelectionBackgroundColor = Color(.secondarySystemFill)
    #endif
}

