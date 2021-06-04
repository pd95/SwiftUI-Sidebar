//
//  Extensions.swift
//  SwiftUI-Sidebar
//
//  Created by Philipp on 03.06.21.
//

import SwiftUI

extension Binding {
    // This returns a binding to Value? and ensures that `nil` values are ignored
    // this allows persisting the selection, independently of the `NavigationLink`s
    // activation/selection animations
    var navigationLinkBinding: Binding<Value?> {
        Binding<Value?> {
            wrappedValue
        } set: { newValue in
            guard let newValue = newValue else {
                print("ignore replacing \(wrappedValue) with nil")
                return
            }
            wrappedValue = newValue
        }
    }
}

enum OperatingSystem {
    case macOS
    case iOS
    case tvOS
    case watchOS

    #if os(macOS)
    static let current = macOS
    #elseif os(iOS)
    static let current = iOS
    #elseif os(tvOS)
    static let current = tvOS
    #elseif os(watchOS)
    static let current = watchOS
    #else
    #error("Unsupported platform")
    #endif
}
