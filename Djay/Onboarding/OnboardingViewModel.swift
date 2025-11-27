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
    private(set) var currentStepViewModel: AnyOnboardingStepViewModel?
    private let factory: OnboardingStepFactory
    private let coordinator: AnyOnboardingCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    init(factory: OnboardingStepFactory, coordinator: AnyOnboardingCoordinator) {
        self.factory = factory
        self.coordinator = coordinator
    }

    func start() {
        checkNextStep()
    }

    private func checkNextStep() {
        if let nextStep = factory.nextStep(after: currentStep) {
            currentStep = nextStep
            if let result = factory.createViewController(for: nextStep, onComplete: checkNextStep) {
                currentStepViewModel = result.viewModel
                navigateToViewController.send(result.viewController)
            }
        } else {
            onboardingComplete.send()
        }
        updatePageIndicator.send((currentPage: (currentStep ?? .welcome).rawValue, totalPages: totalSteps))
    }
    
    var totalSteps: Int { OnboardingStep.allCases.count }
}
