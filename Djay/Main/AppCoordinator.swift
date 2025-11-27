//
//  AppCoordinator.swift
//  Djay
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
    }
    
    private func showMainApp() {
        let mainVC = MainViewController()
        navigationController?.setViewControllers([mainVC], animated: true)
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingDidComplete() {
        showMainApp()
    }
}
