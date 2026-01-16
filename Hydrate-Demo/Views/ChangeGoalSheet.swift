import SwiftUI

struct ChangeGoalSheet: View {
    @EnvironmentObject var viewModel: WaterViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedGoal: Double = 64
    @State private var animateIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 44) {
                    Spacer()

                    // Current vs New
                    VStack(spacing: 28) {
                        VStack(spacing: 6) {
                            Text("CURRENT")
                                .font(Theme.Fonts.smallCaps(10))
                                .tracking(2)
                                .foregroundStyle(Theme.textTertiary)
                            Text("\(Int(min(128, max(32, viewModel.settings.dailyGoal)))) oz")
                                .font(Theme.Fonts.body(20))
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .opacity(animateIn ? 1 : 0)

                        VStack(spacing: 6) {
                            Text("NEW GOAL")
                                .font(Theme.Fonts.smallCaps(10))
                                .tracking(2)
                                .foregroundStyle(Theme.textTertiary)

                            VStack(spacing: 4) {
                                Text("\(Int(selectedGoal))")
                                    .font(Theme.Fonts.displayNumber(68))
                                    .foregroundStyle(Theme.accent)
                                    .shadow(color: Theme.accentGlow, radius: 14)
                                    .contentTransition(.numericText())

                                Text("OUNCES")
                                    .font(Theme.Fonts.smallCaps(11))
                                    .tracking(3)
                                    .foregroundStyle(Theme.textTertiary)
                            }
                        }
                        .scaleEffect(animateIn ? 1 : 0.8)
                        .opacity(animateIn ? 1 : 0)
                    }

                    // Goal Slider
                    GoalSlider(value: $selectedGoal)
                        .padding(.horizontal, 40)
                        .opacity(animateIn ? 1 : 0)

                    Text("Recommended: 64-80 oz daily")
                        .font(Theme.Fonts.body(13))
                        .foregroundStyle(Theme.textTertiary)
                        .opacity(animateIn ? 1 : 0)

                    Spacer()

                    // Save button
                    Button("Save Goal", action: saveGoal)
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 24)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 20)

                    Spacer()
                        .frame(height: 24)
                }
            }
            .navigationTitle("Change Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(TertiaryButtonStyle())
                }
            }
        }
        .interactiveDismissDisabled(false)
        .onAppear {
            // Clamp to valid range (in case old ml value is saved)
            selectedGoal = min(128, max(32, viewModel.settings.dailyGoal))
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateIn = true
            }
        }
    }

    private func saveGoal() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            viewModel.settings.dailyGoal = selectedGoal
        }
        HapticManager.shared.notification(.success)
        dismiss()
    }
}

#Preview {
    ChangeGoalSheet()
        .environmentObject(WaterViewModel.preview)
}
