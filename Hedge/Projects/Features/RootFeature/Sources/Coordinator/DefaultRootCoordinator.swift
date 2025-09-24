//
//  DefaultRootCoordinator.swift
//  RootFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import RetrospectFeature
import RetrospectFeatureInterface
import TradeHistoryFeature
import TradeHistoryFeatureInterface
import StockDomainInterface

public final class DefaultRootCoordinator: RootCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let tabView = TabBarView(
            store: .init(
                initialState: TabBarFeature.State(),
                reducer: {
                    TabBarFeature(coordinator: self)
                }
            )
        )
        
        let viewController = UIHostingController(rootView: tabView)
        navigationController.viewControllers = [viewController]
    }
    
    public func pushToRetrospect(with tradeType: TradeType) {
        let retrospectCoordinator = DefaultRetrospectCoordinator(
            navigationController: self.navigationController,
            tradeType: tradeType
        )
        retrospectCoordinator.parentCoordinator = self
        retrospectCoordinator.start()
    }
}

extension DefaultRootCoordinator {
    public func pushToTradeHistory(tradeType: TradeType, stock: StockSearch) {
        let tradeHistoryCoordinator = DefaultTradeHistoryCoordinator(
            navigationController: navigationController,
            tradeType: tradeType,
            stockSearch: stock
        )
        tradeHistoryCoordinator.parentCoordinator = self
        tradeHistoryCoordinator.start()
    }
}
