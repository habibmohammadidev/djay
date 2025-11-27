# 🚀 Quick Start Guide

Get your onboarding flow running in 5 minutes!

## Step 1: Add Files to Xcode (2 minutes)

1. Open `Djay.xcodeproj` in Xcode
2. Drag the `Onboarding` folder into the `Djay` group in Project Navigator
3. In the dialog:
   - ✅ Check "Copy items if needed"
   - ✅ Check "Create groups"
   - ✅ Select target: "Djay"
   - Click "Add"
4. Drag `OnboardingTests.swift` into the `DjayTests` group
   - ✅ Select target: "DjayTests"

## Step 2: Use SF Symbols (30 seconds)

No need to add custom images! The code already uses SF Symbols as fallbacks:
- `music.note.list` for logo
- `waveform.circle.fill` for hero
- `party.popper.fill` for celebration

## Step 3: Build & Run (1 minute)

1. Select iPhone 15 simulator
2. Press ⌘R
3. Watch the onboarding flow! 🎉

## Step 4: Test It (1 minute)

1. Swipe through steps or tap "Continue"
2. Select a skill level on step 3
3. See the finale adapt to your selection
4. Tap "Let's Go!" to complete

## Step 5: Reset & Replay (30 seconds)

To see onboarding again:

**Option A**: Delete the app from simulator

**Option B**: Add this to your ViewController:
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Debug: Reset onboarding
    // UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
}
```

## ✅ That's It!

Your onboarding flow is now running!

## Next Steps

### Customize Content
Edit `OnboardingStepViewModel.swift`:
```swift
case .welcome:
    return OnboardingStepContent(
        title: "Your Custom Title",  // Change this
        subtitle: "Your subtitle",    // And this
        imageName: "your.image",      // And this
        buttonTitle: "Get Started",   // And this
        backgroundColor: .systemBlue  // And this
    )
```

### Add Custom Images
1. Open `Assets.xcassets`
2. Add image sets named:
   - `djay.logo`
   - `djay.hero`
   - `djay.celebration`
3. The code will automatically use them instead of SF Symbols

### Change Colors
Edit `OnboardingAssets.swift`:
```swift
static let primaryBlue = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) // Now red!
```

### Adjust Animations
Edit `OnboardingStepView.swift` in the `animateIn()` method:
```swift
UIView.animate(
    withDuration: 1.0,  // Slower
    delay: 0.5,         // Later
    usingSpringWithDamping: 0.6,  // Bouncier
    initialSpringVelocity: 0
) {
    self.titleLabel.alpha = 1
    self.titleLabel.transform = .identity
}
```

## Troubleshooting

### "No such module 'Djay'" in tests
```bash
# Clean and rebuild
⌘⇧K (Clean Build Folder)
⌘B (Build)
```

### Images not showing
The SF Symbols should work automatically. If not:
1. Check iOS deployment target is 13.0+
2. Verify image names in `OnboardingStepViewModel.swift`

### Onboarding not showing
Check `SceneDelegate.swift` was updated correctly:
```swift
let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
```

## File Checklist

Make sure these files are in your Xcode project:

```
✅ Djay/Onboarding/
   ✅ Coordinator/OnboardingCoordinator.swift
   ✅ Models/
      ✅ SkillLevel.swift
      ✅ OnboardingStep.swift
      ✅ OnboardingStepContent.swift
      ✅ OnboardingAssets.swift
   ✅ ViewModels/OnboardingStepViewModel.swift
   ✅ Views/
      ✅ OnboardingStepView.swift
      ✅ SkillOptionView.swift
      ✅ PageIndicatorView.swift
   ✅ ViewControllers/
      ✅ OnboardingStepViewController.swift
      ✅ OnboardingPageViewController.swift

✅ DjayTests/OnboardingTests.swift
✅ Djay/SceneDelegate.swift (updated)
```

## Run Tests

Press ⌘U or:
```bash
xcodebuild test -scheme Djay -destination 'platform=iOS Simulator,name=iPhone 15'
```

All tests should pass! ✅

## Documentation

- **README_ONBOARDING.md** - Full user guide
- **ARCHITECTURE.md** - Technical details
- **SETUP_INSTRUCTIONS.md** - Detailed setup
- **IMPLEMENTATION_SUMMARY.md** - What was built

## Need Help?

1. Check the inline code comments
2. Read the documentation files
3. Review the test cases for examples
4. All code follows standard iOS patterns

---

**Enjoy your new onboarding flow!** 🎉

Built with ❤️ using UIKit, MVVM, and zero dependencies.
