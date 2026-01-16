import SwiftUI

// MARK: - Glass Icon (8oz)

struct GlassIcon: View {
    var color: Color = Theme.accent

    var body: some View {
        ZStack {
            // Glass shape - wider at top
            GlassShape()
                .fill(color.opacity(0.3))

            GlassShape()
                .stroke(color, lineWidth: 1.5)

            // Water fill
            GlassShape()
                .fill(color.opacity(0.5))
                .mask(
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: 18)
                    }
                )
        }
        .frame(width: 20, height: 26)
    }
}

struct GlassShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topWidth = rect.width
        let bottomWidth = rect.width * 0.7
        let xOffset = (topWidth - bottomWidth) / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xOffset, y: rect.height))
        path.addLine(to: CGPoint(x: xOffset + bottomWidth, y: rect.height))
        path.addLine(to: CGPoint(x: topWidth, y: 0))
        path.closeSubpath()

        return path
    }
}

// MARK: - Can Icon (12oz)

struct CanIcon: View {
    var color: Color = Theme.accent

    var body: some View {
        ZStack {
            // Can body
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(0.3))
                .frame(width: 18, height: 28)

            RoundedRectangle(cornerRadius: 4)
                .stroke(color, lineWidth: 1.5)
                .frame(width: 18, height: 28)

            // Top rim
            Capsule()
                .fill(color.opacity(0.5))
                .frame(width: 12, height: 3)
                .offset(y: -10)

            // Pull tab hint
            Circle()
                .stroke(color, lineWidth: 1)
                .frame(width: 5, height: 5)
                .offset(x: 2, y: -9)

            // Water fill indication
            RoundedRectangle(cornerRadius: 2)
                .fill(color.opacity(0.5))
                .frame(width: 14, height: 12)
                .offset(y: 5)
        }
        .frame(width: 20, height: 30)
    }
}

// MARK: - Bottle Icon (16oz)

struct BottleIcon: View {
    var color: Color = Theme.accent

    var body: some View {
        ZStack {
            // Bottle shape
            BottleShape()
                .fill(color.opacity(0.3))

            BottleShape()
                .stroke(color, lineWidth: 1.5)

            // Water fill
            BottleShape()
                .fill(color.opacity(0.5))
                .mask(
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: 20)
                    }
                )

            // Cap
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 8, height: 4)
                .offset(y: -15)
        }
        .frame(width: 18, height: 34)
    }
}

struct BottleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let neckWidth: CGFloat = 8
        let neckHeight: CGFloat = 8
        let bodyWidth = rect.width
        let shoulderHeight: CGFloat = 6

        let neckX = (bodyWidth - neckWidth) / 2

        // Start at top left of neck
        path.move(to: CGPoint(x: neckX, y: 0))

        // Neck left side
        path.addLine(to: CGPoint(x: neckX, y: neckHeight))

        // Shoulder curve left
        path.addQuadCurve(
            to: CGPoint(x: 0, y: neckHeight + shoulderHeight),
            control: CGPoint(x: 0, y: neckHeight)
        )

        // Body left side
        path.addLine(to: CGPoint(x: 0, y: rect.height - 3))

        // Bottom left corner
        path.addQuadCurve(
            to: CGPoint(x: 3, y: rect.height),
            control: CGPoint(x: 0, y: rect.height)
        )

        // Bottom
        path.addLine(to: CGPoint(x: bodyWidth - 3, y: rect.height))

        // Bottom right corner
        path.addQuadCurve(
            to: CGPoint(x: bodyWidth, y: rect.height - 3),
            control: CGPoint(x: bodyWidth, y: rect.height)
        )

        // Body right side
        path.addLine(to: CGPoint(x: bodyWidth, y: neckHeight + shoulderHeight))

        // Shoulder curve right
        path.addQuadCurve(
            to: CGPoint(x: neckX + neckWidth, y: neckHeight),
            control: CGPoint(x: bodyWidth, y: neckHeight)
        )

        // Neck right side
        path.addLine(to: CGPoint(x: neckX + neckWidth, y: 0))

        path.closeSubpath()

        return path
    }
}

// MARK: - Previews

#Preview("All Icons") {
    ZStack {
        Theme.background.ignoresSafeArea()

        HStack(spacing: 40) {
            VStack(spacing: 8) {
                GlassIcon()
                Text("8oz")
                    .font(Theme.Fonts.body(12))
                    .foregroundStyle(Theme.textSecondary)
            }

            VStack(spacing: 8) {
                CanIcon()
                Text("12oz")
                    .font(Theme.Fonts.body(12))
                    .foregroundStyle(Theme.textSecondary)
            }

            VStack(spacing: 8) {
                BottleIcon()
                Text("16oz")
                    .font(Theme.Fonts.body(12))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    }
}
