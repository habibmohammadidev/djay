# Onboarding Architecture Guide

## Overview

This onboarding flow uses **MVVM + Coordinator** pattern with UIKit, providing a clean, testable, and maintainable architecture.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      SceneDelegate                          │
│  • Checks UserDefaults for completion status                │
│  • Creates OnboardingCoordinator or shows main app          │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ creates
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                 OnboardingCoordinator                       │
│  • Manages onboarding lifecycle                             │
│  • Handles completion callback                              │
│  • Saves completion state to UserDefaults                   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ creates & presents
                     ▼
┌─────────────────────────────────────────────────────────────┐
│            OnboardingPageViewController                     │
│  • UIPageViewController subclass                            │
│  • Manages horizontal paging between steps                  │
│  • Controls page indicators                                 │
│  • Handles step progression logic                           │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ contains array of
                     ▼
┌─────────────────────────────────────────────────────────────┐
│           OnboardingStepViewController                      │
│  • Generic container for each step                          │
│  • Binds view to view model                                 │
│  • Triggers animations on appearance                        │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ├─────────────┬──────────────┐
                     ▼             ▼              ▼
         ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
         │ViewModel     │  │ View         │  │ Model        │
         │              │  │              │  │              │
         │ • Business   │  │ • UI Layout  │  │ • Step enum  │
         │   logic      │  │ • Animations │  │ • Content    │
         │ • State      │  │ • User input │  │ • Skill      │
         │ • Delegates  │  │              │  │   levels     │
         └──────────────┘  └──────────────┘  └──────────────┘
```

## Component Responsibilities

### 1. Models (Data Layer)

**OnboardingStep.swift**
- Enum defining all possible steps
- Each case represents a screen in the flow
- Provides step index for ordering

**SkillLevel.swift**
- Enum for user skill level options
- Contains display text, emojis, and finale content
- Used to customize step 4

**OnboardingStepContent.swift**
- Struct holding UI content for each step
- Title, subtitle, image, button text, colors
- Immutable configuration

**OnboardingAssets.swift**
- Centralized asset management
- Image loading with fallbacks
- Color and typography constants

### 2. ViewModels (Business Logic Layer)

**OnboardingStepViewModel.swift**
- Creates content for each step type
- Manages skill level selection state
- Validates continue button state
- Delegates user actions to coordinator

**Key Methods:**
```swift
func handleContinue()                    // Process continue button tap
func selectSkillLevel(_ level: SkillLevel) // Update selected skill
var isContinueEnabled: Bool              // Validate if can proceed
```

### 3. Views (Presentation Layer)

**OnboardingStepView.swift**
- Main view for each step
- Handles layout with Auto Layout
- Implements coordinated animations
- Manages skill selection UI

**SkillOptionView.swift**
- Radio button-style option view
- Animated selection state
- Tap gesture handling

**PageIndicatorView.swift**
- Dot indicators for current page
- Animated transitions between dots
- Dynamic dot count

### 4. ViewControllers (Coordination Layer)

**OnboardingStepViewController.swift**
- Lightweight container
- Binds view to view model
- Triggers animations on appearance
- Forwards user actions

**OnboardingPageViewController.swift**
- Manages UIPageViewController
- Controls step progression
- Handles skill selection → finale transition
- Manages page indicators
- Implements swipe navigation

### 5. Coordinator (Navigation Layer)

**OnboardingCoordinator.swift**
- Entry point for onboarding flow
- Creates and presents page view controller
- Handles completion callback
- Persists completion state
- Transitions to main app

## Data Flow

### Forward Flow (User Action → State Change)

```
User taps button
       ↓
OnboardingStepView.onContinue()
       ↓
OnboardingStepViewModel.handleContinue()
       ↓
OnboardingStepViewModelDelegate.didTapContinue()
       ↓
OnboardingPageViewController.didTapContinue()
       ↓
OnboardingPageViewController.goToNextStep()
       ↓
UIPageViewController.setViewControllers()
       ↓
New step appears with animation
```

### Skill Selection Flow

```
User selects skill level
       ↓
SkillOptionView.onTap()
       ↓
OnboardingStepView.handleSkillSelection()
       ↓
OnboardingStepViewModel.selectSkillLevel()
       ↓
OnboardingStepViewModelDelegate.didSelectSkillLevel()
       ↓
OnboardingPageViewController.showFinale(with: skillLevel)
       ↓
Create finale step with selected skill
       ↓
Animate to finale screen
```

### Completion Flow

```
User taps "Let's Go!" on finale
       ↓
OnboardingPageViewController.didTapContinue()
       ↓
OnboardingPageViewControllerDelegate.onboardingDidComplete()
       ↓
OnboardingCoordinator.finish()
       ↓
Save to UserDefaults
       ↓
OnboardingCoordinatorDelegate.onboardingCoordinatorDidFinish()
       ↓
SceneDelegate transitions to main app
```

## Key Design Patterns

### 1. MVVM (Model-View-ViewModel)
- **Model**: Pure data structures (OnboardingStep, SkillLevel)
- **View**: UI components (OnboardingStepView, SkillOptionView)
- **ViewModel**: Business logic (OnboardingStepViewModel)
- **Binding**: Closures and delegates

### 2. Coordinator
- Manages navigation flow
- Decouples view controllers from navigation logic
- Handles app-level transitions

### 3. Delegation
- ViewModels delegate to ViewControllers
- ViewControllers delegate to Coordinator
- Coordinator delegates to SceneDelegate

### 4. Factory Pattern
- `makeContent(for:)` creates step content
- `createViewController(for:)` creates VCs
- Centralized object creation

### 5. Strategy Pattern
- Different content strategies per step
- Skill level determines finale content
- Easily extensible for new steps

## Testing Strategy

### Unit Tests
- ViewModel logic (state, validation)
- Model properties (skill levels, content)
- Coordinator state management

### Integration Tests
- Step progression flow
- Skill selection → finale transition
- Completion → persistence

### UI Tests
- Button taps and navigation
- Animation completion
- Multi-device layouts

## Extension Points

### Adding New Steps
1. Add case to `OnboardingStep` enum
2. Add content in `makeContent(for:)`
3. Add to step array in `setupInitialSteps()`

### Custom Step Types
1. Create new view model subclass
2. Create custom view
3. Update factory method in coordinator

### Analytics Integration
Add tracking in:
- `OnboardingStepViewModel.handleContinue()`
- `OnboardingPageViewController.didTapContinue()`
- `OnboardingCoordinator.finish()`

### A/B Testing
- Create multiple content variants
- Use feature flags in `makeContent(for:)`
- Track variant in analytics

## Performance Considerations

- **Lazy Loading**: View controllers created on-demand
- **Memory**: Only 2-3 VCs in memory at once (UIPageViewController)
- **Animations**: Hardware-accelerated Core Animation
- **Images**: Lazy loaded, cached by UIImage
- **State**: Minimal state in UserDefaults

## Thread Safety

- All UI updates on main thread
- UserDefaults access is thread-safe
- No background processing needed

## Accessibility

Future enhancements:
- VoiceOver labels
- Dynamic Type support
- Reduced motion support
- High contrast colors

## Localization

To add localization:
1. Create `Localizable.strings`
2. Replace hardcoded strings with `NSLocalizedString`
3. Add to `makeContent(for:)` method

## Dependencies

**Zero external dependencies!**
- UIKit (system framework)
- Foundation (system framework)
- XCTest (testing only)

This keeps the app lightweight and reduces maintenance burden.
