//
//  DefaultLoginCoordinator.swift
//  LoginFeature
//
//  Created by Junyoung on 10/25/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI

import LoginFeatureInterface
import Core
import AuthDomainInterface
import Shared

public final class DefaultLoginCoordinator: LoginCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var type: Core.CoordinatorType = .login
    
    private let authRepository = DIContainer.resolve(AuthRepository.self)
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        Task { @MainActor in
            let builder: LoginBuilderProtocol = LoginViewBuilder()
            let view = await builder.build(coordinator: self, authRepository: authRepository)
            let hosting = UIHostingController(rootView: AnyView(view))
            navigationController.pushViewController(hosting, animated: false)
        }
    }
}
