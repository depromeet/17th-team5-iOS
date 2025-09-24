//
//  DefaultTradeHistoryCoordinator.swift
//  TradeHistoryFeature
//
//  Created by Junyoung on 9/24/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI

import Core
import StockDomainInterface
import TradeHistoryFeatureInterface

public final class DefaultTradeHistoryCoordinator: TradeHistoryCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var parentCoordinator: RootCoordinator?
    public let stockSearch: StockSearch
    
    public init(
        navigationController: UINavigationController,
        stockSearch: StockSearch
    ) {
        self.navigationController = navigationController
        self.stockSearch = stockSearch
    }
    
    public func start() {
        let viewController = UIHostingController(
            rootView: TradeHistoryInputView(
                store: .init(
                    initialState: TradeHistoryFeature.State(
                        stock: stockSearch
                    ),
                    reducer: {
                    TradeHistoryFeature(coordinator: self)
                })
            )
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func popToPrev() {
        navigationController.popViewController(animated: true)
    }
}
