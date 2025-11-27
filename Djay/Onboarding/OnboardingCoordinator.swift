//
//  OnboardingCoordinator.swift
//  Djay
//

import UIKit
import Combine

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingDidComplete()
}

protocol AnyOnboardingCoordinator {
    func start()
}

class OnboardingCoordinator: AnyOnboardingCoordinator {
    weak var delegate: OnboardingCoordinatorDelegate?
    private weak var navigationController: UINavigationController?
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let factory = OnboardingStepFactory()
        let viewModel = OnboardingViewModel(factory: factory, coordinator: self)
        let onboardingVC = OnboardingViewController(viewModel: viewModel)
        
        viewModel.onboardingComplete
            .sink { [weak self] in self?.finish() }
            .store(in: &cancellables)
        
        navigationController?.setViewControllers([onboardingVC], animated: false)
    }
    
    private func finish() {
        delegate?.onboardingDidComplete()
    }
}
