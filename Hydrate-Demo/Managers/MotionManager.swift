import SwiftUI
import CoreMotion
import Combine

@MainActor
class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var displayLink: CADisplayLink?

    // Water physics simulation
    @Published var waterTilt: Double = 0      // How much the water surface tilts (-1 to 1)
    @Published var waterVelocity: Double = 0  // For wave intensity

    private var tiltVelocity: Double = 0

    // Physics constants
    private let damping: Double = 0.92
    private let stiffness: Double = 0.1

    private let updateInterval: TimeInterval = 1.0 / 60.0

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }

        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical)

        // Use CADisplayLink for smoother animation synced to display refresh
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120)
        displayLink?.add(to: .main, forMode: .common)
    }

    func stopMonitoring() {
        displayLink?.invalidate()
        displayLink = nil
        motionManager.stopDeviceMotionUpdates()
    }

    @objc private func update() {
        updateMotionData()
    }

    private func updateMotionData() {
        guard let motion = motionManager.deviceMotion else { return }

        // Just use gravity.x for left/right tilt
        // Tilt right = positive, tilt left = negative
        let targetTilt = max(-1, min(1, motion.gravity.x * 1.2))

        // Spring physics
        let accel = stiffness * (targetTilt - waterTilt)
        tiltVelocity = (tiltVelocity + accel) * damping
        waterTilt += tiltVelocity
        waterTilt = max(-1, min(1, waterTilt))

        // Wave intensity from velocity
        waterVelocity = min(1.0, abs(tiltVelocity) * 12)
    }
}

// Preview helper for simulator
extension MotionManager {
    static var preview: MotionManager {
        let manager = MotionManager()
        manager.waterTilt = 0.3
        manager.waterVelocity = 0.2
        return manager
    }
}
