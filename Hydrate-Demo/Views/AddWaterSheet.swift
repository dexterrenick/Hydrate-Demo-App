import SwiftUI

struct AddWaterSheet: View {
    @EnvironmentObject var viewModel: WaterViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var amount: Double = 8
    @State private var animateIn = false

    private let minAmount: Double = 1
    private let maxAmount: Double = 64
    private let glassSize: Double = 8  // Each glass represents 8oz

    private var numberOfGlasses: Int {
        Int(ceil(amount / glassSize))
    }

    private var lastGlassFill: Double {
        let remainder = amount.truncatingRemainder(dividingBy: glassSize)
        return remainder == 0 ? 1.0 : remainder / glassSize
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Glasses visualization
                    glassesView
                        .frame(height: 140)
                        .opacity(animateIn ? 1 : 0)
                        .scaleEffect(animateIn ? 1 : 0.9)

                    Spacer()
                        .frame(height: 40)

                    // Amount display
                    VStack(spacing: 6) {
                        Text("\(Int(amount))")
                            .font(Theme.Fonts.displayNumber(72))
                            .foregroundStyle(Theme.accent)
                            .shadow(color: Theme.accentGlow, radius: 16)
                            .contentTransition(.numericText())

                        Text("OUNCES")
                            .font(Theme.Fonts.smallCaps(12))
                            .tracking(3)
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .opacity(animateIn ? 1 : 0)

                    Spacer()
                        .frame(height: 50)

                    // Slider
                    sliderView
                        .padding(.horizontal, 32)
                        .opacity(animateIn ? 1 : 0)

                    Spacer()

                    // Add button
                    Button(action: addWater) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .medium))
                            Text("Add Water")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, 24)
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 20)

                    Spacer()
                        .frame(height: 24)
                }
            }
            .navigationTitle("Add Water")
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
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateIn = true
            }
        }
    }

    private var glassesView: some View {
        let maxPerRow = 4
        let rows = stride(from: 0, to: numberOfGlasses, by: maxPerRow).map { start in
            Array(start..<min(start + maxPerRow, numberOfGlasses))
        }

        return VStack(spacing: 10) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { index in
                        let isLastGlass = index == numberOfGlasses - 1
                        let fill = isLastGlass ? lastGlassFill : 1.0

                        MiniGlassView(fill: fill)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: numberOfGlasses)
        .animation(.easeOut(duration: 0.2), value: amount)
    }

    private var sliderView: some View {
        GeometryReader { geometry in
            let thumbRadius: CGFloat = 16
            let trackWidth = geometry.size.width - thumbRadius * 2
            let progress = (amount - minAmount) / (maxAmount - minAmount)
            let thumbX = thumbRadius + progress * trackWidth

            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(Theme.backgroundTertiary)
                    .frame(height: 8)
                    .padding(.horizontal, thumbRadius)

                // Filled track
                Capsule()
                    .fill(Theme.buttonGradient)
                    .frame(width: max(8, thumbX - thumbRadius + 4), height: 8)
                    .padding(.leading, thumbRadius)
                    .shadow(color: Theme.accentGlow, radius: 6)

                // Thumb
                Circle()
                    .fill(Theme.accent)
                    .overlay(
                        Circle()
                            .fill(.white.opacity(0.3))
                            .padding(6)
                    )
                    .frame(width: thumbRadius * 2, height: thumbRadius * 2)
                    .shadow(color: Theme.accentGlow, radius: 8)
                    .position(x: thumbX, y: 16)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let clampedX = max(thumbRadius, min(geometry.size.width - thumbRadius, gesture.location.x))
                                let newProgress = (clampedX - thumbRadius) / trackWidth
                                let rawValue = minAmount + (maxAmount - minAmount) * newProgress
                                let newValue = round(rawValue)

                                if newValue != amount {
                                    amount = max(minAmount, min(maxAmount, newValue))
                                    HapticManager.shared.sliderDetent()
                                }
                            }
                    )
            }
        }
        .frame(height: 32)
    }

    private func addWater() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            viewModel.addWater(amount)
        }
        dismiss()
    }
}

// MARK: - Mini Glass View

struct MiniGlassView: View {
    let fill: Double

    var body: some View {
        ZStack {
            // Glass outline
            RoundedRectangle(cornerRadius: 8)
                .fill(Theme.backgroundSecondary)
                .frame(width: 44, height: 60)

            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.glassStroke, lineWidth: 1.5)
                .frame(width: 44, height: 60)

            // Water fill
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            colors: [Theme.waterTop, Theme.waterBottom],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 38, height: max(0, 52 * fill))
                    .padding(.bottom, 3)
            }
            .frame(width: 44, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    AddWaterSheet()
        .environmentObject(WaterViewModel.preview)
}

#Preview("16oz") {
    AddWaterSheet()
        .environmentObject(WaterViewModel.preview)
}
