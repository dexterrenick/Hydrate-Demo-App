//
//  Hydrate_DemoApp.swift
//  Hydrate-Demo
//
//  Created by Dexter Renick on 1/14/26.
//

import SwiftUI

@main
struct Hydrate_DemoApp: App {
    @StateObject private var waterViewModel = WaterViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(waterViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
