import SwiftUI

enum Theme {
    // Primary accent - elegant teal/cyan
    static let accent = Color(red: 0.35, green: 0.82, blue: 0.92)
    static let accentDark = Color(red: 0.18, green: 0.55, blue: 0.72)

    // Backgrounds - deep navy blue
    static let background = Color(red: 0.04, green: 0.05, blue: 0.12)
    static let backgroundSecondary = Color(red: 0.07, green: 0.08, blue: 0.16)
    static let backgroundTertiary = Color(red: 0.10, green: 0.12, blue: 0.22)

    // Glass colors
    static let glassStroke = Color.white.opacity(0.12)
    static let glassHighlight = Color.white.opacity(0.06)

    // Water gradient
    static let waterTop = Color(red: 0.3, green: 0.78, blue: 0.92).opacity(0.9)
    static let waterMiddle = Color(red: 0.2, green: 0.58, blue: 0.82).opacity(0.75)
    static let waterBottom = Color(red: 0.1, green: 0.35, blue: 0.6).opacity(0.6)

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.65)
    static let textTertiary = Color.white.opacity(0.4)

    // Button gradient
    static let buttonGradient = LinearGradient(
        colors: [accent, accentDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Subtle glow for accent elements
    static let accentGlow = accent.opacity(0.35)

    // MARK: - Typography

    struct Fonts {
        // Hero titles - light weight, wide tracking
        static func hero(_ size: CGFloat) -> Font {
            .system(size: size, weight: .light, design: .default)
        }

        // Display numbers - thin for elegance
        static func displayNumber(_ size: CGFloat) -> Font {
            .system(size: size, weight: .thin, design: .default)
        }

        // Headings - medium weight
        static func heading(_ size: CGFloat) -> Font {
            .system(size: size, weight: .medium, design: .default)
        }

        // Body text - regular weight
        static func body(_ size: CGFloat) -> Font {
            .system(size: size, weight: .regular, design: .default)
        }

        // Labels - slightly heavier for readability
        static func label(_ size: CGFloat) -> Font {
            .system(size: size, weight: .medium, design: .default)
        }

        // Small caps style for labels
        static func smallCaps(_ size: CGFloat) -> Font {
            .system(size: size, weight: .semibold, design: .default)
        }

        // Button text
        static func button() -> Font {
            .system(size: 17, weight: .semibold, design: .default)
        }
    }
}

// MARK: - View Extensions for Typography

extension View {
    func heroText() -> some View {
        self.tracking(2)
    }

    func labelText() -> some View {
        self.tracking(1.2)
            .textCase(.uppercase)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.Fonts.button())
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Theme.buttonGradient, in: RoundedRectangle(cornerRadius: 14))
            .shadow(color: Theme.accentGlow, radius: configuration.isPressed ? 8 : 16, y: configuration.isPressed ? 2 : 6)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.Fonts.label(15))
            .foregroundStyle(Theme.accent)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Theme.accent.opacity(configuration.isPressed ? 0.2 : 0.12), in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Theme.accent.opacity(0.25), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct TertiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.Fonts.body(16))
            .foregroundStyle(Theme.accent.opacity(configuration.isPressed ? 0.6 : 1))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
