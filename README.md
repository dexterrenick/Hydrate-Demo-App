# Hydrate Demo App

A SwiftUI iOS application demonstrating modern animation techniques and haptic feedback patterns through an interactive hydration tracker.

## Overview

Hydrate is a demo application that showcases how to create engaging user experiences using iOS animation APIs and Core Haptics. The app allows users to track their daily water intake while demonstrating various animation and haptic feedback techniques.

## Features

### Animation Demonstrations

- **Spring-based animations** - Smooth, physics-based transitions throughout the interface
- **Water physics simulation** - Real-time liquid rendering with wave effects that respond to device motion
- **Particle effects** - Floating bubbles that react to water level changes
- **Numeric text transitions** - Animated number updates for progress display
- **Staggered view animations** - Coordinated entry and exit animations

### Haptic Feedback Patterns

- **Water glug effect** - Multi-tap pattern simulating drinking sounds
- **Goal completion celebration** - Ascending intensity pattern for achievements
- **Milestone feedback** - Double-tap patterns at 25%, 50%, and 75% progress
- **Slider detents** - Light impact feedback when adjusting values

### Motion Integration

- Device tilt detection via Core Motion
- Water surface responds to device orientation
- Spring physics with damping for smooth motion

## Project Structure

```
Hydrate-Demo/
├── Models/          - Data models for water logs and settings
├── ViewModels/      - State management
├── Views/           - Main screens (Dashboard, Onboarding)
├── Components/      - Reusable UI components
├── Managers/        - Haptic and Motion managers
└── Theme.swift      - Centralized design system
```

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Getting Started

1. Clone the repository
2. Open `Hydrate-Demo.xcodeproj` in Xcode
3. Build and run on a physical device to experience haptics and motion features

## Key Technical Highlights

- **Core Haptics** for custom haptic pattern authoring
- **Core Motion** for gyroscope and accelerometer data
- **CADisplayLink** for high-framerate physics updates
- **SwiftUI Shape protocol** for custom water rendering
- **Spring animations** with configurable response and damping

## License

This project is provided as a demonstration and learning resource.
