//
//  ListRowHelper.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 19.05.21.
//

import SwiftUI

struct SelectedListItemBackground: View {
    let isSelected: Bool

    var body: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor)
        }
    }
}

struct SelectedListItemOverlay: View {
    let isSelected: Bool
    
    var body: some View {
        if isSelected {
            Image(systemName: "chevron.right")
        }
    }
}
