//
//  DefaultRetrospectionCoordinator.swift
//  RetrospectionFeature
//
//  Created by 이중엽 on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import RetrospectionFeatureInterface
import RetrospectionDomainInterface
import Shared

public final class DefaultRetrospectionCoordinator: RetrospectionCoordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .retrospection
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    private let retrospectionId: Int
    
    public init(navigationController: UINavigationController, retrospectionId: Int) {
        self.navigationController = navigationController
        self.retrospectionId = retrospectionId
    }
    
    public func start() {
        let useCase = DIContainer.resolve(FetchRetrospectionDetailUseCase.self)
        
        let feature = RetrospectionFeature(
            coordinator: self,
            fetchRetrospectionDetailUseCase: useCase
        )
        
        let view = RetrospectionView(
            store: Store(
                initialState: RetrospectionFeature.State(retrospectionId: retrospectionId),
                reducer: { feature }
            )
        )
        
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    public func popToPrev() {
        finish()
    }
}
