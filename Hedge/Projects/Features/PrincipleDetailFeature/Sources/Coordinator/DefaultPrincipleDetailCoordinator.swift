//
//  DefaultPrincipleDetailCoordinator.swift
//  PrincipleDetailFeature
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import PrincipleDetailFeatureInterface
import PrinciplesDomainInterface
import Shared

public final class DefaultPrincipleDetailCoordinator: PrincipleDetailCoordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .principleDetail
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    private let principleGroup: PrincipleGroup
    private let isRecommended: Bool
    
    public init(navigationController: UINavigationController, principleGroup: PrincipleGroup, isRecommended: Bool) {
        self.navigationController = navigationController
        self.principleGroup = principleGroup
        self.isRecommended = isRecommended
    }
    
    public func start() {
        let createPrincipleGroupUseCase = DIContainer.resolve(CreatePrincipleGroupUseCase.self)
        
        let feature = PrincipleDetailFeature(
            coordinator: self,
            createPrincipleGroupUseCase: createPrincipleGroupUseCase
        )
        
        let view = PrincipleDetailView(
            store: Store(
                initialState: PrincipleDetailFeature.State(
                    principleGroup: principleGroup,
                    isRecommended: isRecommended
                ),
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

