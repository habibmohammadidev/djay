//
//  OnboardingViewModel.swift
//  Djay
//

import UIKit
import Combine

class OnboardingViewModel {
    let navigateToViewController = PassthroughSubject<AnyOnboardingStepView, Never>()
    let updatePageIndicator = PassthroughSubject<(currentPage: Int, totalPages: Int), Never>()
    let onboardingComplete = PassthroughSubject<Void, Never>()
    
    private(set) var currentStep: OnboardingStep?
    private let factory: OnboardingStepFactory
    private var cancellables = Set<AnyCancellable>()
    
    init(factory: OnboardingStepFactory) {
        self.factory = factory
    }

    func start() {
        checkNextStep()
    }

    private func checkNextStep() {
        if let nextStep = factory.nextStep(after: currentStep) {
            currentStep = nextStep
            if let vc = factory.createViewController(for: nextStep, onComplete: checkNextStep) {
                navigateToViewController.send(vc)
            }
        } else {
            onboardingComplete.send()
        }
        updatePageIndicator.send((currentPage: (currentStep ?? .welcome).rawValue, totalPages: totalSteps))
    }
    
    var totalSteps: Int { OnboardingStep.allCases.count }
}
