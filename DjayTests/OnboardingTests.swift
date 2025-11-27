//
//  OnboardingTests.swift
//  DjayTests
//

import XCTest
@testable import Djay

class OnboardingStepViewModelTests: XCTestCase {
    
    func testWelcomeStepContent() {
        let viewModel = WelcomeStepViewModel()
        
        XCTAssertEqual(viewModel.buttonTitle, "Continue")
    }
    
    func testFeaturesStepContent() {
        let viewModel = FeaturesStepViewModel()
        
        XCTAssertEqual(viewModel.buttonTitle, "Continue")
    }
    
    func testSkillSelectionRequiresSelection() {
        let viewModel = SkillSelectionStepViewModel()
        
        XCTAssertFalse(viewModel.isContinueEnabled)
        XCTAssertNil(viewModel.selectedLevel)
        
        viewModel.selectSkillLevel(.beginner)
        
        XCTAssertTrue(viewModel.isContinueEnabled)
        XCTAssertEqual(viewModel.selectedLevel, .beginner)
    }
    
    func testFinaleStepContent() {
        let viewModel = FinaleStepViewModel(skillLevel: .beginner)
        
        XCTAssertEqual(viewModel.buttonTitle, "Get Started")
        XCTAssertEqual(viewModel.skillLevel, .beginner)
    }
    
    func testSkillLevelProperties() {
        XCTAssertEqual(SkillLevel.beginner.emoji, "🎧")
        XCTAssertEqual(SkillLevel.intermediate.emoji, "🎵")
        XCTAssertEqual(SkillLevel.professional.emoji, "🎛️")
        
        XCTAssertFalse(SkillLevel.beginner.finaleTitle.isEmpty)
        XCTAssertFalse(SkillLevel.intermediate.finaleSubtitle.isEmpty)
    }
    
    func testOnboardingStepIndices() {
        XCTAssertEqual(OnboardingStep.welcome.rawValue, 0)
        XCTAssertEqual(OnboardingStep.features.rawValue, 1)
        XCTAssertEqual(OnboardingStep.skillSelection.rawValue, 2)
        XCTAssertEqual(OnboardingStep.finale.rawValue, 3)
    }
}

class OnboardingCoordinatorTests: XCTestCase {
    
    func testOnboardingCoordinatorInitialization() {
        let navController = UINavigationController()
        let coordinator = OnboardingCoordinator(navigationController: navController)
        
        XCTAssertNotNil(coordinator)
    }
}

class SkillLevelTests: XCTestCase {
    
    func testAllCasesCount() {
        XCTAssertEqual(SkillLevel.allCases.count, 3)
    }
    
    func testRawValues() {
        XCTAssertEqual(SkillLevel.beginner.rawValue, "I'm new to DJing")
        XCTAssertEqual(SkillLevel.intermediate.rawValue, "I've used DJ apps before")
        XCTAssertEqual(SkillLevel.professional.rawValue, "I'm a professional DJ")
    }
}
