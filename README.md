# Djay

An iOS music application that provides an interactive audio synthesis experience with customizable sound parameters.

## Overview

Djay is a music app featuring:
- **Audio Synthesis Controls**: Three interactive knobs to control frequency (100-1000 Hz), amplitude (0-1), and vibration (0-10 Hz)
- **Real-time Playback**: Start/stop audio playback with live parameter adjustments
- **Onboarding Flow**: Multi-step guided introduction including:
  - Welcome screen with animated logo
  - Features overview
  - Skill level selection (Beginner/Intermediate/Advanced)
  - Finale screen with smooth transitions
- **Custom UI Components**: Gradient backgrounds, custom knob controls, and animated page indicators

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.0+

## Architecture

- MVVM pattern
- Coordinator pattern for navigation
- Protocol-oriented design

## Project Structure

- `Main/` - Home screen and app coordinator
- `Onboarding/` - Multi-step onboarding flow
- `Extensions/` - UIKit and Foundation extensions
- `Assets/` - Images and resources

## Setup

1. Clone the repository
2. Open `Djay.xcodeproj`
3. Build and run

