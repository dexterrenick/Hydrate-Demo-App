//
//  ContentView.swift
//  Hydrate-Demo
//
//  Created by Dexter Renick on 1/14/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WaterViewModel

    var body: some View {
        Group {
            if viewModel.settings.hasCompletedOnboarding {
                DashboardView()
            } else {
                OnboardingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.5), value: viewModel.settings.hasCompletedOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(WaterViewModel.preview)
}

#Preview("Onboarding") {
    ContentView()
        .environmentObject(WaterViewModel.previewOnboarding)
}
