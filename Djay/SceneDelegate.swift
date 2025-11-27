//
//  SceneDelegate.swift
//  Djay
//
//  Created by Habibollah Mohammadi on 20.11.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let mainViewController = ViewController()
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}