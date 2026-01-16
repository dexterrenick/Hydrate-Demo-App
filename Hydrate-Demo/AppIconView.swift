import SwiftUI

/// Preview this view and take a screenshot at 1024x1024 for the app icon
struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.08, blue: 0.18),
                    Color(red: 0.02, green: 0.03, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Subtle radial glow behind drop
            RadialGradient(
                colors: [
                    Color(red: 0.35, green: 0.82, blue: 0.92).opacity(0.3),
                    Color.clear
                ],
                center: .center,
                startRadius: 50,
                endRadius: 300
            )

            // Water drop
            Image(systemName: "drop.fill")
                .font(.system(size: 400, weight: .thin))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.45, green: 0.88, blue: 0.95),
                            Color(red: 0.35, green: 0.82, blue: 0.92),
                            Color(red: 0.25, green: 0.65, blue: 0.85)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color(red: 0.35, green: 0.82, blue: 0.92).opacity(0.6), radius: 40)
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview {
    AppIconView()
}
