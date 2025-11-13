//
//  DefaultRetrospectionCoordinator.swift
//  RetrospectionFeature
//
//  Created by 이중엽 on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI

import Core
import RetrospectionFeatureInterface

public final class DefaultRetrospectionCoordinator: RetrospectionCoordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .retrospection
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let view = RetrospectionView()
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    public func popToPrev() {
        finish()
    }
}
