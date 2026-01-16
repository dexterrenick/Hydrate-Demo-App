import Foundation

struct WaterLog: Identifiable, Codable {
    let id: UUID
    let amount: Double // in milliliters
    let timestamp: Date

    init(id: UUID = UUID(), amount: Double, timestamp: Date = Date()) {
        self.id = id
        self.amount = amount
        self.timestamp = timestamp
    }
}

extension WaterLog {
    static let previewSample = WaterLog(amount: 250)
}
