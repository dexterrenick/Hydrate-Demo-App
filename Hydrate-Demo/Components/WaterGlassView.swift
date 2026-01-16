import SwiftUI

struct WaterGlassView: View {
    let progress: Double
    let waterTilt: Double       // How much water surface tilts (-1 to 1)
    let waterVelocity: Double   // Current velocity for wave intensity (0 to 1)

    @State private var wavePhase: Double = 0

    private let glassWidth: CGFloat = 180
    private let glassHeight: CGFloat = 280
    private let cornerRadius: CGFloat = 24

    var body: some View {
        ZStack {
            // Glass outline (background)
            glassShape
                .fill(Theme.backgroundSecondary)

            glassShape
                .stroke(Theme.glassStroke, lineWidth: 2)

            // Water fill
            waterFill
                .clipShape(glassShape)

            // Glass highlight (glossy effect)
            glassHighlight
                .clipShape(glassShape)

            // Percentage label
            if progress > 0 {
                percentageLabel
            }
        }
        .frame(width: glassWidth, height: glassHeight)
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                wavePhase = .pi * 2
            }
        }
    }

    private var glassShape: some Shape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }

    private var waterFill: some View {
        GeometryReader { geometry in
            let waterHeight = geometry.size.height * progress

            // Tilt: -1 to 1 maps to ±50px
            let tiltAmount: CGFloat = CGFloat(waterTilt) * 50

            // Wave amplitude
            let amplitude: CGFloat = 4 + CGFloat(waterVelocity) * 8

            ZStack {
                // Main water
                WaterWaveShape(
                    phase: wavePhase,
                    amplitude: amplitude,
                    tiltAmount: tiltAmount
                )
                .fill(
                    LinearGradient(
                        colors: [
                            Theme.waterTop,
                            Theme.waterMiddle,
                            Theme.waterBottom
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: waterHeight + 40)
                .offset(y: geometry.size.height - waterHeight - 20)

                // Secondary wave for depth
                WaterWaveShape(
                    phase: wavePhase + .pi,
                    amplitude: amplitude * 0.5,
                    tiltAmount: tiltAmount
                )
                .fill(Theme.accent.opacity(0.15))
                .frame(height: waterHeight + 30)
                .offset(y: geometry.size.height - waterHeight - 10)

                // Bubbles
                BubblesView(waterHeight: waterHeight, baseY: geometry.size.height - waterHeight)
            }
        }
    }

    private var glassHighlight: some View {
        GeometryReader { geometry in
            // Left edge highlight
            LinearGradient(
                colors: [.white.opacity(0.12), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 40)
            .offset(x: 8)

            // Top rim highlight
            Rectangle()
                .fill(.white.opacity(0.1))
                .frame(height: 2)
                .offset(y: 2)
        }
    }

    private var percentageLabel: some View {
        Text("\(Int(progress * 100))%")
            .font(Theme.Fonts.displayNumber(46))
            .foregroundStyle(.white.opacity(0.95))
            .shadow(color: Theme.accent.opacity(0.5), radius: 14)
    }
}

// MARK: - Water Wave Shape

struct WaterWaveShape: Shape {
    var phase: Double
    var amplitude: CGFloat
    var tiltAmount: CGFloat

    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.height))

        // Draw sine wave across the top
        for x in stride(from: 0, through: rect.width, by: 2) {
            let normalizedX = x / rect.width

            // Tilt: water higher on one side
            let tilt = tiltAmount * (normalizedX - 0.5) * 2

            // Simple sine wave
            let wave = sin((normalizedX * .pi * 2) + CGFloat(phase)) * amplitude

            let y = tilt + wave

            if x == 0 {
                path.addLine(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()

        return path
    }
}

// MARK: - Bubbles

struct BubblesView: View {
    let waterHeight: CGFloat
    let baseY: CGFloat

    @State private var bubbles: [Bubble] = []

    var body: some View {
        GeometryReader { geometry in
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(.white.opacity(bubble.opacity))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
            }
        }
        .onAppear {
            generateBubbles()
        }
        .onChange(of: waterHeight) { _, _ in
            generateBubbles()
        }
    }

    private func generateBubbles() {
        guard waterHeight > 30 else {
            bubbles = []
            return
        }

        bubbles = (0..<8).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 30...150),
                    y: CGFloat.random(in: baseY + 20...baseY + waterHeight - 10)
                ),
                size: CGFloat.random(in: 3...8),
                opacity: Double.random(in: 0.2...0.5)
            )
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
    let opacity: Double
}

// MARK: - Preview

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        WaterGlassView(progress: 0.65, waterTilt: 0.2, waterVelocity: 0.2)
    }
}

#Preview("Tilted Left") {
    ZStack {
        Theme.background.ignoresSafeArea()
        WaterGlassView(progress: 0.5, waterTilt: -0.7, waterVelocity: 0.4)
    }
}

#Preview("Tilted Right") {
    ZStack {
        Theme.background.ignoresSafeArea()
        WaterGlassView(progress: 0.5, waterTilt: 0.7, waterVelocity: 0.4)
    }
}

#Preview("Calm") {
    ZStack {
        Theme.background.ignoresSafeArea()
        WaterGlassView(progress: 0.7, waterTilt: 0, waterVelocity: 0)
    }
}
