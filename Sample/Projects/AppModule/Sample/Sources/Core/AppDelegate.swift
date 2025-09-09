//
//  AppDelegate.swift
//  Sample
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit

import Umbrella

import Swinject
import Shared

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerDependencies()
        
        return true
    }
}

// MARK: - Extension
extension AppDelegate {
    /// 의존성 등록
    private func registerDependencies() {
        DIContainer.register(assemblies: [
            DataAssembly(),
            DomainAssembly()
        ])
    }
}
