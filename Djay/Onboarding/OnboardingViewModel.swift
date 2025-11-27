//
//  OnboardingViewModel.swift
//  Djay
//

import UIKit

protocol OnboardingViewModelDelegate: AnyObject {
    func shouldNavigateToViewController(_ viewController: UIViewController & OnboardingTransitionable)
    func shouldUpdatePageIndicator(currentPage: Int, totalPages: Int)
    func onboardingDidComplete()
}

class OnboardingViewModel {
    weak var delegate: OnboardingViewModelDelegate?
    private(set) var currentStep: OnboardingStep = .welcome
    private var selectedSkillLevel: SkillLevel?
    private let factory: OnboardingStepFactory
    
    init(factory: OnboardingStepFactory) {
        self.factory = factory
    }
    
    func completeCurrentStep(with data: Any? = nil) { //TODO: Habib remove Data
        if let skillLevel = data as? SkillLevel {
            selectedSkillLevel = skillLevel
        }
        
        if let nextStep = factory.nextStep(after: currentStep, selectedSkillLevel: selectedSkillLevel) {
            currentStep = nextStep
            if let vc = factory.createViewController(for: nextStep, skillLevel: selectedSkillLevel) {
                delegate?.shouldNavigateToViewController(vc)
                delegate?.shouldUpdatePageIndicator(currentPage: currentStep.rawValue, totalPages: totalSteps)
            }
        } else {
            delegate?.onboardingDidComplete()
        }
    }
    
    func getInitialViewController() -> (UIViewController & OnboardingTransitionable)? {
        factory.createViewController(for: .welcome, skillLevel: nil)
    }
    
    var totalSteps: Int { OnboardingStep.allCases.count }
}
