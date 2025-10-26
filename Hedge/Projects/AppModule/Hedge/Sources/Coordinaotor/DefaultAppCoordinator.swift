//
//  DefaultAppCoordinator.swift
//  Sample
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit

import Core
import RootFeature
import LoginFeature
import Shared
import AuthDomainInterface

final class DefaultAppCoordinator: AppCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .app
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let authRepository = DIContainer.resolve(AuthRepository.self)
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if authRepository.isAuthorized() {
            mainFlow()
        } else {
            loginFlow()
        }
    }
    
    func loginFlow() {
        let loginCoordinator = DefaultLoginCoordinator(
            navigationController: navigationController
        )
        loginCoordinator.finishDelegate = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func mainFlow() {
        let rootCoordinator = DefaultRootCoordinator(
            navigationController: navigationController
        )
        rootCoordinator.finishDelegate = self
        childCoordinators.append(rootCoordinator)
        rootCoordinator.start()
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: any Core.Coordinator) {
        Log.debug("Coordinator Finish : \(childCoordinator)")
        
        self.childCoordinators.removeAll{ $0.type == childCoordinator.type }
        navigationController.viewControllers.removeAll()
        start()
    }
}
