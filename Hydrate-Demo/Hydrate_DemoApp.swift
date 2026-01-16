//
//  Hydrate_DemoApp.swift
//  Hydrate-Demo
//
//  Created by Dexter Renick on 1/14/26.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@main
struct Hydrate_DemoApp: App {
    @StateObject private var waterViewModel = WaterViewModel()

    init() {
        #if canImport(UIKit)
        // Set window background to theme color to prevent white flash on launch
        let backgroundColor = UIColor(red: 0.04, green: 0.05, blue: 0.12, alpha: 1.0)
        UIWindow.appearance().backgroundColor = backgroundColor
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(waterViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
