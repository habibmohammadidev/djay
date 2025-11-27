//
//  SceneDelegate.swift
//  Djay
//
//  Created by Habibollah Mohammadi on 20.11.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let coordinator = AppCoordinator(window: window)
        appCoordinator = coordinator
        coordinator.start()
    }
}
