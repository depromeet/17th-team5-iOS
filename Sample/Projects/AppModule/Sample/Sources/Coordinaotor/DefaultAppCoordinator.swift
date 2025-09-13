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

final class DefaultAppCoordinator: AppCoordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let rootCoordinator = DefaultRootCoordinator(
            navigationController: navigationController
        )
        rootCoordinator.start()
    }
}
