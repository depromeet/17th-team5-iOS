//
//  AppDelegate.swift
//  Sample
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit

import Swinject

import DesignKit
import Shared
import Umbrella

import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerDependencies()
        
        if let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KakaoNativeAppKey") as? String {
            print(kakaoNativeAppKey)
            KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        }
        return true
    }
}

// MARK: - Extension
extension AppDelegate {
    /// 의존성 등록
    private func registerDependencies() {
        DIContainer.register(assemblies: [
            DataAssembly(),
            DomainAssembly(),
            HedgeFont()
        ])
    }
}
