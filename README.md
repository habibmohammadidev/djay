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
- **Orientation Support**: Full support for portrait and landscape modes with adaptive layouts

## Requirements

- iOS 15.0+

## Architecture

- MVVM-C (Model-View-ViewModel-Coordinator) pattern
- Coordinator pattern for navigation flow
- Protocol-oriented design

## Animations

The app features a comprehensive animation system designed for consistency and ease of customization:

- **Onboarding Transitions**: Flexible system with default slide in/out behavior between steps. Custom animations easily implemented per view (e.g., logo fade transition from Welcome to Features screen) via `OnboardingTransitionable` protocol
- **Main App Transition**: Smooth fade-out animation when transitioning from onboarding to main app
- **Interactive Elements**: Buttons and UI options feature custom animations, isolated to prevent misuse and maintain design consistency

## Project Structure

- `Main/` - Home screen and app coordinator
- `Onboarding/` - Multi-step onboarding flow
- `Extensions/` - UIKit and Foundation extensions
- `Assets/` - Images and resources

## Demo

- [Portrait Demo](Screenshots/demo_portraint.mov)
- [Landscape Demo](Screenshots/demo_landscape.mov)

## Setup

1. Clone the repository
2. Open `Djay.xcodeproj`
3. Build and run

