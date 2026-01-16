import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: WaterViewModel
    @StateObject private var motionManager = MotionManager()
    @State private var showingAddSheet = false
    @State private var showingGoalSheet = false
    @State private var animateIn = false

    var body: some View {
        ZStack {
            // Background
            Theme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                header
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : -20)

                Spacer()

                // Water Glass
                WaterGlassView(
                    progress: viewModel.progress,
                    waterTilt: motionManager.waterTilt,
                    waterVelocity: motionManager.waterVelocity
                )
                .frame(height: 340)
                .opacity(animateIn ? 1 : 0)
                .scaleEffect(animateIn ? 1 : 0.8)

                // Progress text
                progressInfo
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 20)

                Spacer()

                // Quick add buttons
                quickAddButtons
                    .opacity(animateIn ? 1 : 0)
                    .offset(y: animateIn ? 0 : 30)

                Spacer()
                    .frame(height: 20)
            }
            .padding(.horizontal, 24)
        }
        .fullScreenCover(isPresented: $showingAddSheet) {
            AddWaterSheet()
        }
        .fullScreenCover(isPresented: $showingGoalSheet) {
            ChangeGoalSheet()
        }
        .toast(
            isShowing: $viewModel.showUndoToast,
            message: "Added \(Int(viewModel.lastAddedAmount)) oz"
        ) {
            withAnimation(.spring(response: 0.4)) {
                viewModel.undoLastAdd()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.1)) {
                animateIn = true
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("TODAY")
                    .font(Theme.Fonts.smallCaps(11))
                    .tracking(2)
                    .foregroundStyle(Theme.textTertiary)

                Text(Date.now, format: .dateTime.weekday(.wide).month().day())
                    .font(Theme.Fonts.heading(22))
                    .foregroundStyle(Theme.textPrimary)
            }

            Spacer()

            Menu {
                Button("Reset Today", systemImage: "arrow.counterclockwise") {
                    viewModel.resetToday()
                }
                Button("Change Goal", systemImage: "slider.horizontal.3") {
                    showingGoalSheet = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 40, height: 40)
                    .background(Theme.accent.opacity(0.12), in: Circle())
                    .overlay(
                        Circle()
                            .stroke(Theme.accent.opacity(0.25), lineWidth: 1)
                    )
            }
        }
    }

    private var progressInfo: some View {
        VStack(spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(Int(viewModel.todaysTotal))")
                    .font(Theme.Fonts.displayNumber(54))
                    .foregroundStyle(Theme.accent)
                    .shadow(color: Theme.accentGlow, radius: 10)
                    .contentTransition(.numericText())

                Text("/ \(Int(viewModel.settings.dailyGoal)) oz")
                    .font(Theme.Fonts.body(18))
                    .foregroundStyle(Theme.textSecondary)
            }

            if viewModel.isGoalComplete {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                    Text("Goal Complete")
                        .font(Theme.Fonts.label(13))
                        .tracking(0.5)
                }
                .foregroundStyle(.green)
                .shadow(color: .green.opacity(0.3), radius: 8)
                .transition(.scale.combined(with: .opacity))
            } else {
                Text("\(Int(viewModel.remainingAmount)) oz to go")
                    .font(Theme.Fonts.body(14))
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .animation(.spring(response: 0.4), value: viewModel.isGoalComplete)
    }

    private var quickAddButtons: some View {
        VStack(spacing: 14) {
            Text("QUICK ADD")
                .font(Theme.Fonts.smallCaps(10))
                .tracking(2)
                .foregroundStyle(Theme.textTertiary)

            HStack(spacing: 10) {
                QuickAddButton(amount: 8, icon: AnyView(GlassIcon())) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        viewModel.addWater(8)
                    }
                }

                QuickAddButton(amount: 12, icon: AnyView(CanIcon())) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        viewModel.addWater(12)
                    }
                }

                QuickAddButton(amount: 16, icon: AnyView(BottleIcon())) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        viewModel.addWater(16)
                    }
                }

                // Custom amount button
                Button(action: { showingAddSheet = true }) {
                    VStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(Theme.accent)
                            .frame(height: 32)

                        Text("Custom")
                            .font(Theme.Fonts.body(12))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.accent.opacity(0.25), lineWidth: 1)
                    )
                }
                .buttonStyle(BounceButtonStyle())
            }
        }
    }
}

struct QuickAddButton: View {
    let amount: Double
    let icon: AnyView
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                icon
                    .frame(height: 32)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(Int(amount))")
                        .font(Theme.Fonts.heading(17))
                        .foregroundStyle(Theme.textPrimary)
                    Text("oz")
                        .font(Theme.Fonts.body(11))
                        .foregroundStyle(Theme.textTertiary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.25), lineWidth: 1)
            )
        }
        .buttonStyle(BounceButtonStyle())
    }
}

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    DashboardView()
        .environmentObject(WaterViewModel.preview)
}

#Preview("Empty") {
    DashboardView()
        .environmentObject(WaterViewModel.previewEmpty)
}
