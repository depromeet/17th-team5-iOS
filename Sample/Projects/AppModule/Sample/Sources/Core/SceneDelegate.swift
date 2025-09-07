//
//  SceneDelegate.swift
//  Sample
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit

import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        configureAppScene(scene)
    }
}

extension SceneDelegate {
    private func configureAppScene(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = BaseNavigationController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator = DefaultAppCoordinator(
            navigationController: navigationController
        )
        appCoordinator?.start()
    }
}
