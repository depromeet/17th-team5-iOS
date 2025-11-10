//
//  DefaultSettingCoordinator.swift
//  SettingFeature
//
//  Created by Junyoung on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import Shared
import AuthDomainInterface
import SettingFeatureInterface

public final class DefaultSettingCoordinator: SettingCoordinator {
    public var navigationController: UINavigationController
    
    public var parentCoordinator: (any RootCoordinator)?
    
    public var childCoordinators: [any Core.Coordinator] = []
    
    public var finishDelegate: (any Core.CoordinatorFinishDelegate)?
    
    public var type: Core.CoordinatorType { .setting }
    
    public let authRepository = DIContainer.resolve(AuthRepository.self)
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewModel = SettingViewModel(authRepository: authRepository)
        viewModel.coordinator = self
        let view = SettingView(viewModel: viewModel)
        let hostingViewController = UIHostingController(rootView: view)
        
        self.navigationController.pushViewController(hostingViewController, animated: true)
    }
    
    public func signOut() {
        DispatchQueue.main.async {
            self.parentCoordinator?.signOut()
        }
    }
}
