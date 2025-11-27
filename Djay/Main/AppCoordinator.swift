//
//  AppCoordinator.swift
//  Djay
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator(window: window)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
    }
    
    private func showMainApp() {
        let mainVC = MainViewController()
        window.rootViewController = mainVC
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingDidComplete() {
        showMainApp()
    }
}
