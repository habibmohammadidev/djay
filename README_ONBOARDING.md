# Djay Onboarding Flow

A professional, animated 4-step onboarding flow built with UIKit and MVVM architecture.

## Architecture

### MVVM + Coordinator Pattern
- **Models**: `OnboardingStep`, `SkillLevel`, `OnboardingStepContent`
- **ViewModels**: `OnboardingStepViewModel` - handles business logic and state
- **Views**: `OnboardingStepView`, `SkillOptionView`, `PageIndicatorView` - reusable UI components
- **ViewControllers**: `OnboardingStepViewController`, `OnboardingPageViewController` - manage view lifecycle
- **Coordinator**: `OnboardingCoordinator` - manages navigation flow and completion

## Features

✅ **Dynamic Step Configuration**: Add/remove/reorder steps easily via the `OnboardingStep` enum  
✅ **Responsive Layout**: Works on all iPhone sizes (SE to 16 Pro Max) in portrait & landscape  
✅ **Beautiful Animations**: Coordinated fade/slide animations using UIKit Core Animation  
✅ **State Management**: Skill level selection persists through the flow  
✅ **Adaptive Finale**: Step 4 content changes based on selected skill level  
✅ **Page Indicators**: Visual dots showing current step  
✅ **Persistence**: Remembers completion state via UserDefaults  
✅ **Unit Tests**: Comprehensive tests for ViewModels and flow logic  

## File Structure

```
Djay/Onboarding/
├── Coordinator/
│   └── OnboardingCoordinator.swift          # Flow orchestration
├── Models/
│   ├── OnboardingStep.swift                 # Step enum
│   ├── SkillLevel.swift                     # Skill level options
│   └── OnboardingStepContent.swift          # Step content model
├── ViewModels/
│   └── OnboardingStepViewModel.swift        # Business logic
├── Views/
│   ├── OnboardingStepView.swift             # Main step view
│   ├── SkillOptionView.swift                # Radio button option
│   └── PageIndicatorView.swift              # Page dots
└── ViewControllers/
    ├── OnboardingStepViewController.swift   # Step container
    └── OnboardingPageViewController.swift   # Page management
```

## How to Run

1. Open `Djay.xcodeproj` in Xcode
2. Build and run (⌘R)
3. The onboarding flow will appear automatically on first launch
4. To reset and see it again: Delete the app or run:
   ```swift
   UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
   ```

## Customization Guide

### Adding a New Step

1. Add a case to `OnboardingStep` enum:
```swift
enum OnboardingStep {
    case welcome
    case features
    case skillSelection
    case newStep  // Add here
    case finale(skillLevel: SkillLevel)
}
```

2. Add content in `OnboardingStepViewModel.makeContent()`:
```swift
case .newStep:
    return OnboardingStepContent(
        title: "New Feature",
        subtitle: "Description here",
        imageName: "icon.name",
        buttonTitle: "Next",
        backgroundColor: .systemBlue
    )
```

3. Add to the flow in `OnboardingPageViewController.setupInitialSteps()`:
```swift
let steps: [OnboardingStep] = [.welcome, .features, .newStep, .skillSelection]
```

### Changing Step Content

Edit the `makeContent(for:)` method in `OnboardingStepViewModel.swift`:
```swift
case .welcome:
    return OnboardingStepContent(
        title: "Your New Title",
        subtitle: "Your new subtitle",
        imageName: "your.image.name",
        buttonTitle: "Get Started",
        backgroundColor: UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
    )
```

### Adjusting Animations

Modify timing in `OnboardingStepView.animateIn()`:
```swift
// Change duration (0.6), delay (0.1-0.4), damping (0.8)
UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
    self.titleLabel.alpha = 1
    self.titleLabel.transform = .identity
}
```

### Customizing Skill Levels

Edit `SkillLevel.swift`:
```swift
enum SkillLevel: String, CaseIterable {
    case beginner = "I'm new to DJing"
    case expert = "I'm an expert"  // Modify or add
    
    var finaleTitle: String {
        switch self {
        case .beginner: return "Welcome!"
        case .expert: return "Let's Go Pro!"
        }
    }
}
```

### Changing Colors & Styling

Colors are defined in each step's content. Global styling can be adjusted in:
- `OnboardingStepView.swift` - fonts, spacing, button styling
- `SkillOptionView.swift` - radio button colors
- `PageIndicatorView.swift` - dot colors

Example:
```swift
continueButton.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)
titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
```

### Removing Page Indicators

In `OnboardingPageViewController.swift`, comment out:
```swift
// private func setupPageIndicator() { ... }
```

## Testing

Run tests with ⌘U or:
```bash
xcodebuild test -scheme Djay -destination 'platform=iOS Simulator,name=iPhone 15'
```

Tests cover:
- Step content generation
- Skill level selection logic
- State persistence
- View model behavior

## Design Notes

- **Auto Layout**: All constraints use NSLayoutConstraint, no storyboards
- **Animations**: Spring animations with 0.6s duration, 0.8 damping
- **Spacing**: 32pt horizontal margins, 16-32pt vertical spacing
- **Typography**: System font, 32pt bold titles, 17pt regular body
- **Colors**: Dark gradient backgrounds with blue accent (#4D9AFF)

## Performance

- Smooth 60fps animations on iPhone SE and newer
- Lazy view controller creation
- Minimal memory footprint
- No third-party dependencies

## Future Enhancements

- [ ] Add swipe gestures between steps
- [ ] Implement skip button
- [ ] Add video backgrounds
- [ ] Localization support
- [ ] Analytics tracking
- [ ] A/B testing framework

## Support

For questions or issues, refer to the inline code documentation or create an issue in the repository.
