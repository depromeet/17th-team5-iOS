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
import PrincipleReviewFeatureInterface
import PrincipleReviewFeature
import LinkDomainInterface
import Shared
import SwiftUI
import SplashFeature

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var splashWindow: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        configureAppScene(scene)
    }
}

// MARK: - Extension
extension SceneDelegate {
    private func configureAppScene(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = BaseNavigationController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        // SplashView를 별도 window로 표시
        let splashView = SplashView()
        let splashViewController = UIHostingController(rootView: splashView)
        splashWindow = UIWindow(windowScene: windowScene)
        splashWindow?.rootViewController = splashViewController
        splashWindow?.windowLevel = .normal + 1
        splashWindow?.backgroundColor = .white
        splashWindow?.makeKeyAndVisible()
        
        // 1.5초 후 coordinator 시작 및 SplashWindow 제거
        appCoordinator = DefaultAppCoordinator(
            navigationController: navigationController
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // coordinator를 먼저 시작하여 메인 화면이 준비되도록 함
            self.appCoordinator?.start()
            
            // 약간의 딜레이 후 SplashWindow를 fade out 애니메이션으로 제거
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.splashWindow?.alpha = 0
                }) { _ in
                    self.splashWindow?.isHidden = true
                    self.splashWindow = nil
                }
            }
        }
    }
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        if let url = URLContexts.first?.url,
           AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
}
