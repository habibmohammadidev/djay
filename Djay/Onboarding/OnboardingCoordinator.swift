//
//  OnboardingCoordinator.swift
//  Djay
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingDidComplete()
}

class OnboardingCoordinator {
    weak var delegate: OnboardingCoordinatorDelegate?
    private let window: UIWindow
    private var onboardingViewController: OnboardingViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let factory = OnboardingStepFactory()
        let viewModel = OnboardingViewModel(factory: factory)
        let onboardingVC = OnboardingViewController(viewModel: viewModel)
        
        onboardingVC.modalPresentationStyle = .fullScreen
        
        self.onboardingViewController = onboardingVC
        window.rootViewController = onboardingVC
        window.makeKeyAndVisible()
    }
    
    private func finish() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        delegate?.onboardingDidComplete()
    }
}
