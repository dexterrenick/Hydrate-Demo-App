import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: WaterViewModel
    @State private var selectedGoal: Double = 64
    @State private var animateIn = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 48) {
                Spacer()

                // Hero
                VStack(spacing: 20) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 72, weight: .ultraLight))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.accent, Theme.accentDark],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Theme.accentGlow, radius: 24)
                        .scaleEffect(animateIn ? 1 : 0.5)
                        .opacity(animateIn ? 1 : 0)

                    Text("HYDRATE")
                        .font(Theme.Fonts.hero(38))
                        .tracking(8)
                        .foregroundStyle(Theme.textPrimary)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 20)

                    Text("Set your daily water goal")
                        .font(Theme.Fonts.body(16))
                        .foregroundStyle(Theme.textSecondary)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 20)
                }

                Spacer()

                // Goal Picker
                VStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("\(Int(selectedGoal))")
                            .font(Theme.Fonts.displayNumber(72))
                            .foregroundStyle(Theme.accent)
                            .shadow(color: Theme.accentGlow, radius: 16)
                            .contentTransition(.numericText())

                        Text("OUNCES")
                            .font(Theme.Fonts.smallCaps(12))
                            .tracking(3)
                            .foregroundStyle(Theme.textTertiary)
                    }

                    GoalSlider(value: $selectedGoal)
                        .padding(.horizontal, 40)

                    Text("Recommended: 64-80 oz daily")
                        .font(Theme.Fonts.body(13))
                        .foregroundStyle(Theme.textTertiary)
                }
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 30)

                Spacer()

                // CTA Button
                Button("Get Started") {
                    viewModel.completeOnboarding(withGoal: selectedGoal)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
                .opacity(animateIn ? 1 : 0)
                .offset(y: animateIn ? 0 : 40)

                Spacer()
                    .frame(height: 24)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.75).delay(0.1)) {
                animateIn = true
            }
        }
    }
}

struct GoalSlider: View {
    @Binding var value: Double

    private let range: ClosedRange<Double> = 32...128
    private let step: Double = 8

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(Theme.backgroundTertiary)
                    .frame(height: 6)

                // Filled portion
                Capsule()
                    .fill(Theme.buttonGradient)
                    .frame(width: thumbPosition(in: geometry.size.width), height: 6)
                    .shadow(color: Theme.accentGlow, radius: 6)

                // Thumb
                Circle()
                    .fill(Theme.accent)
                    .overlay(
                        Circle()
                            .fill(.white.opacity(0.25))
                            .padding(5)
                    )
                    .shadow(color: Theme.accentGlow, radius: 10)
                    .frame(width: 26, height: 26)
                    .offset(x: thumbPosition(in: geometry.size.width) - 13)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                updateValue(from: gesture.location.x, in: geometry.size.width)
                            }
                    )
            }
        }
        .frame(height: 26)
    }

    private func thumbPosition(in width: CGFloat) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(percent) * width
    }

    private func updateValue(from x: CGFloat, in width: CGFloat) {
        let percent = max(0, min(1, x / width))
        let rawValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percent)
        let steppedValue = (rawValue / step).rounded() * step
        let clampedValue = max(range.lowerBound, min(range.upperBound, steppedValue))

        if clampedValue != value {
            value = clampedValue
            HapticManager.shared.sliderDetent()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(WaterViewModel.previewOnboarding)
}
