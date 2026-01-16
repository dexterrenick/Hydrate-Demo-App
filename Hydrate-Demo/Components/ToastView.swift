import SwiftUI

struct ToastView: View {
    let message: String
    let undoAction: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.green)

                Text(message)
                    .font(Theme.Fonts.body(14))
                    .foregroundStyle(Theme.textPrimary)
            }

            Spacer()

            Button(action: undoAction) {
                Text("Undo")
                    .font(Theme.Fonts.label(14))
                    .foregroundStyle(Theme.accent)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.glassStroke, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 16, y: 8)
        )
        .padding(.horizontal, 20)
    }
}

// View modifier for showing toast
struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let undoAction: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                Spacer()

                if isShowing {
                    ToastView(message: message, undoAction: {
                        undoAction()
                        withAnimation(.spring(response: 0.3)) {
                            isShowing = false
                        }
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 32)
                }
            }
        }
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                // Auto-dismiss after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.spring(response: 0.3)) {
                        isShowing = false
                    }
                }
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String, undoAction: @escaping () -> Void) -> some View {
        modifier(ToastModifier(isShowing: isShowing, message: message, undoAction: undoAction))
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()

        ToastView(message: "Added 8 oz", undoAction: {})
    }
}
