//
//  SceneDelegate.swift
//  TestMovieApp
//
//  Created by Максим Вечирко on 18.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let presenter = LoginPresenter(authService: AuthServiceManager())
        let presentingView = LoginController(presenter: presenter)
        presenter.output = presentingView
        window?.rootViewController = presentingView
        window?.makeKeyAndVisible()
    }
}

