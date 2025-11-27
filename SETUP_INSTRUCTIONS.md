# Setup Instructions

## Adding Files to Xcode Project

The onboarding files have been created in the file system. Now you need to add them to your Xcode project:

### Step 1: Add Files to Xcode

1. Open `Djay.xcodeproj` in Xcode
2. Right-click on the `Djay` folder in the Project Navigator
3. Select "Add Files to Djay..."
4. Navigate to `Djay/Onboarding/` folder
5. Select the entire `Onboarding` folder
6. Make sure these options are checked:
   - ✅ "Copy items if needed"
   - ✅ "Create groups"
   - ✅ Add to target: "Djay"
7. Click "Add"

### Step 2: Add Test File

1. Right-click on `DjayTests` folder
2. Select "Add Files to Djay..."
3. Navigate to and select `OnboardingTests.swift`
4. Make sure it's added to target: "DjayTests"
5. Click "Add"

### Step 3: Add Placeholder Images

Since we don't have the actual Figma assets, add placeholder images to Assets.xcassets:

1. Open `Assets.xcassets`
2. Click the "+" button at the bottom
3. Select "New Image Set"
4. Name it `djay.logo`
5. Repeat for:
   - `djay.hero`
   - `djay.celebration`

**Alternative**: Use SF Symbols (no setup needed):
- Replace `djay.logo` with `"music.note.list"` in code
- Replace `djay.hero` with `"waveform.circle.fill"`
- Replace `djay.celebration` with `"party.popper.fill"`

To use SF Symbols, update `OnboardingStepViewModel.swift`:

```swift
case .welcome:
    return OnboardingStepContent(
        title: "Welcome to djay",
        subtitle: "The professional DJ app for iPhone",
        imageName: "music.note.list",  // SF Symbol
        buttonTitle: "Continue",
        backgroundColor: UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0)
    )
```

### Step 4: Build and Run

1. Select a simulator (iPhone 15 recommended)
2. Press ⌘R to build and run
3. The onboarding flow should appear

### Step 5: Reset Onboarding (Optional)

To see the onboarding again after completion:

**Option A**: Delete and reinstall the app

**Option B**: Add a debug button in your main app:
```swift
Button("Reset Onboarding") {
    UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    // Restart app
}
```

## Troubleshooting

### Build Errors

If you see "No such module 'Djay'" in tests:
1. Select the `Djay` scheme
2. Product → Clean Build Folder (⌘⇧K)
3. Build again (⌘B)

### Files Not Found

If Xcode can't find the files:
1. Check that files are in the correct directory
2. In Xcode, select the file in Project Navigator
3. Open File Inspector (⌘⌥1)
4. Check "Target Membership" includes "Djay"

### Images Not Showing

If images don't appear:
1. Use SF Symbols as described above, or
2. Add actual image assets to Assets.xcassets
3. Make sure image names match exactly

## Next Steps

1. Replace placeholder images with actual Figma assets
2. Adjust colors to match your brand
3. Fine-tune animation timing
4. Add analytics tracking
5. Test on physical devices

## File Checklist

Ensure these files exist:

```
✅ Djay/Onboarding/Models/
   ✅ SkillLevel.swift
   ✅ OnboardingStep.swift
   ✅ OnboardingStepContent.swift

✅ Djay/Onboarding/ViewModels/
   ✅ OnboardingStepViewModel.swift

✅ Djay/Onboarding/Views/
   ✅ OnboardingStepView.swift
   ✅ SkillOptionView.swift
   ✅ PageIndicatorView.swift

✅ Djay/Onboarding/ViewControllers/
   ✅ OnboardingStepViewController.swift
   ✅ OnboardingPageViewController.swift

✅ Djay/Onboarding/Coordinator/
   ✅ OnboardingCoordinator.swift

✅ DjayTests/
   ✅ OnboardingTests.swift

✅ Djay/
   ✅ SceneDelegate.swift (updated)
```

All files have been created and are ready to be added to your Xcode project!
