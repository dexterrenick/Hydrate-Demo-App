import SwiftUI
import Combine

@MainActor
class WaterViewModel: ObservableObject {
    @Published var settings: UserSettings {
        didSet { saveSettings() }
    }
    @Published var todaysLogs: [WaterLog] = []
    @Published var isShowingAddWater = false
    @Published var showUndoToast = false
    @Published var lastAddedAmount: Double = 0

    private var lastAddedLog: WaterLog?
    private let settingsKey = "user_settings"
    private let logsKey = "water_logs"

    var todaysTotal: Double {
        todaysLogs.reduce(0) { $0 + $1.amount }
    }

    var progress: Double {
        min(todaysTotal / settings.dailyGoal, 1.0)
    }

    var progressPercentage: Int {
        Int(progress * 100)
    }

    var remainingAmount: Double {
        max(settings.dailyGoal - todaysTotal, 0)
    }

    var isGoalComplete: Bool {
        todaysTotal >= settings.dailyGoal
    }

    init() {
        self.settings = UserSettings()
        loadSettings()
        loadTodaysLogs()
    }

    // MARK: - Water Logging

    func addWater(_ amount: Double) {
        let log = WaterLog(amount: amount)
        todaysLogs.append(log)
        saveLogs()

        // Track for undo
        lastAddedLog = log
        lastAddedAmount = amount

        // Show undo toast
        withAnimation(.spring(response: 0.4)) {
            showUndoToast = true
        }

        // Check for milestones
        let previousProgress = (todaysTotal - amount) / settings.dailyGoal
        let currentProgress = progress

        if currentProgress >= 1.0 && previousProgress < 1.0 {
            HapticManager.shared.goalComplete()
        } else if crossedMilestone(from: previousProgress, to: currentProgress) {
            HapticManager.shared.milestone()
        } else {
            HapticManager.shared.waterGlug()
        }
    }

    func undoLastAdd() {
        guard let log = lastAddedLog else { return }

        todaysLogs.removeAll { $0.id == log.id }
        saveLogs()
        lastAddedLog = nil

        HapticManager.shared.impact(.medium)
    }

    private func crossedMilestone(from: Double, to: Double) -> Bool {
        let milestones = [0.25, 0.5, 0.75]
        for milestone in milestones {
            if from < milestone && to >= milestone {
                return true
            }
        }
        return false
    }

    func removeLog(_ log: WaterLog) {
        todaysLogs.removeAll { $0.id == log.id }
        saveLogs()
        HapticManager.shared.impact(.light)
    }

    func resetToday() {
        todaysLogs.removeAll()
        saveLogs()
        HapticManager.shared.notification(.warning)
    }

    // MARK: - Onboarding

    func completeOnboarding(withGoal goal: Double) {
        settings.dailyGoal = goal
        settings.hasCompletedOnboarding = true
        HapticManager.shared.notification(.success)
    }

    // MARK: - Persistence

    private func loadSettings() {
        guard let data = UserDefaults.standard.data(forKey: settingsKey),
              let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) else {
            return
        }
        settings = decoded
    }

    private func saveSettings() {
        guard let encoded = try? JSONEncoder().encode(settings) else { return }
        UserDefaults.standard.set(encoded, forKey: settingsKey)
    }

    private func loadTodaysLogs() {
        guard let data = UserDefaults.standard.data(forKey: logsKey),
              let allLogs = try? JSONDecoder().decode([WaterLog].self, from: data) else {
            return
        }

        // Filter to only today's logs
        let calendar = Calendar.current
        todaysLogs = allLogs.filter { calendar.isDateInToday($0.timestamp) }
    }

    private func saveLogs() {
        guard let encoded = try? JSONEncoder().encode(todaysLogs) else { return }
        UserDefaults.standard.set(encoded, forKey: logsKey)
    }
}

// MARK: - Preview

extension WaterViewModel {
    static var preview: WaterViewModel {
        let vm = WaterViewModel()
        vm.settings = UserSettings(dailyGoal: 64, hasCompletedOnboarding: true)
        vm.todaysLogs = [
            WaterLog(amount: 8),
            WaterLog(amount: 12),
            WaterLog(amount: 8),
        ]
        return vm
    }

    static var previewEmpty: WaterViewModel {
        let vm = WaterViewModel()
        vm.settings = UserSettings(dailyGoal: 64, hasCompletedOnboarding: true)
        return vm
    }

    static var previewOnboarding: WaterViewModel {
        let vm = WaterViewModel()
        vm.settings = UserSettings(dailyGoal: 64, hasCompletedOnboarding: false)
        return vm
    }
}
