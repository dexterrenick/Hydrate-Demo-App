import SwiftUI
import CoreHaptics

@MainActor
class HapticManager: ObservableObject {
    static let shared = HapticManager()

    private var engine: CHHapticEngine?

    private init() {
        prepareHaptics()
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()

            engine?.resetHandler = { [weak self] in
                do {
                    try self?.engine?.start()
                } catch {
                    print("Failed to restart haptic engine: \(error)")
                }
            }
        } catch {
            print("Failed to create haptic engine: \(error)")
        }
    }

    // MARK: - Simple Haptics

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    // MARK: - Custom Haptic Patterns

    func waterGlug() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else {
            impact(.medium)
            return
        }

        var events: [CHHapticEvent] = []

        // Create a "glug glug glug" pattern
        let glugCount = 3
        for i in 0..<glugCount {
            let time = Double(i) * 0.15
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6 - Float(i) * 0.1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)

            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: time
            )
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play water glug haptic: \(error)")
        }
    }

    func goalComplete() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else {
            notification(.success)
            return
        }

        var events: [CHHapticEvent] = []

        // Celebratory ascending pattern
        let notes: [(time: Double, intensity: Float, sharpness: Float)] = [
            (0.0, 0.4, 0.5),
            (0.1, 0.6, 0.6),
            (0.2, 0.8, 0.7),
            (0.35, 1.0, 0.8),
            (0.5, 0.6, 0.4),
        ]

        for note in notes {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: note.intensity)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: note.sharpness)

            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: note.time
            )
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play goal complete haptic: \(error)")
        }
    }

    func milestone() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else {
            notification(.success)
            return
        }

        var events: [CHHapticEvent] = []

        // Double tap pattern for milestones (25%, 50%, 75%)
        for i in 0..<2 {
            let time = Double(i) * 0.12
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: time
            )
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play milestone haptic: \(error)")
        }
    }

    func sliderDetent() {
        impact(.light)
    }
}
