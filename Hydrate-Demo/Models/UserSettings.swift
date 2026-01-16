import Foundation

struct UserSettings: Codable {
    var dailyGoal: Double // in ounces
    var hasCompletedOnboarding: Bool

    init(dailyGoal: Double = 64, hasCompletedOnboarding: Bool = false) {
        self.dailyGoal = dailyGoal
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    // Common glass sizes in oz
    static let quickAddAmounts: [Double] = [8, 12, 16]

    // Goal range for picker (32oz - 128oz)
    static let goalRange = stride(from: 32.0, through: 128.0, by: 8.0).map { $0 }
}

extension UserSettings {
    var dailyGoalFormatted: String {
        "\(Int(dailyGoal)) oz"
    }
}
