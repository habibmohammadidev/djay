//
//  OnboardingStepFactory.swift
//  Djay
//

import UIKit

class OnboardingStepFactory {
    private var cachedViewControllers: [OnboardingStep: (AnyOnboardingStepView, AnyOnboardingStepViewModel)] = [:]
    
    func nextStep(after currentStep: OnboardingStep?) -> OnboardingStep? {
        guard let currentStep else { return .welcome }
        return switch currentStep {
        case .welcome: .features
        case .features: .skillSelection
        case .skillSelection: .finale
        case .finale: nil
        }
    }
    
    func createViewController(for step: OnboardingStep, onComplete: @escaping () -> Void) -> (viewController: AnyOnboardingStepView, viewModel: AnyOnboardingStepViewModel)? {
        if let cached = cachedViewControllers[step] {
            return cached
        }
        
        let viewController: AnyOnboardingStepView
        let viewModel: AnyOnboardingStepViewModel
        
        switch step {
        case .welcome:
            let vm = WelcomeStepViewModel(onComplete: onComplete)
            viewController = WelcomeStepViewController(viewModel: vm)
            viewModel = vm
        case .features:
            let vm = FeaturesStepViewModel(onComplete: onComplete)
            viewController = FeaturesStepViewController(viewModel: vm)
            viewModel = vm
        case .skillSelection:
            let vm = SkillSelectionStepViewModel(onComplete: onComplete)
            viewController = SkillSelectionStepViewController(viewModel: vm)
            viewModel = vm
        case .finale:
            let vm = FinaleStepViewModel(onComplete: onComplete)
            viewController = FinaleStepViewController(viewModel: vm)
            viewModel = vm
        }
        
        let result = (viewController, viewModel)
        cachedViewControllers[step] = result
        return result
    }
}
