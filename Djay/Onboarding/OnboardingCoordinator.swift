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
        let viewModel = OnboardingViewModel()
        let onboardingVC = OnboardingViewController(viewModel: viewModel)
        
        viewModel.skillSelectionDelegate = onboardingVC
        onboardingVC.delegate = self
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

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func onboardingDidComplete() {
        finish()
    }
}
