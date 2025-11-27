//
//  AppCoordinator.swift
//  Djay
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    private let fadeDelegate = FadeNavigationDelegate()
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.delegate = fadeDelegate
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
    }
    
    private func showMainApp() {
        let mainVC = HomeViewController(viewModel: HomeViewModel())
        navigationController?.setViewControllers([mainVC], animated: true)
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingDidComplete() {
        showMainApp()
    }
}
