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
    public let tradeType: TradeType
    public let stockSearch: StockSearch
    
    public init(
        navigationController: UINavigationController,
        tradeType: TradeType,
        stockSearch: StockSearch
    ) {
        self.navigationController = navigationController
        self.stockSearch = stockSearch
        self.tradeType = tradeType
    }
    
    public func start() {
        let viewController = UIHostingController(
            rootView: TradeHistoryInputView(
                store: .init(
                    initialState: TradeHistoryFeature.State(
                        tradeType: tradeType,
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
    
    public func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory) {
        parentCoordinator?.pushToPrinciples(tradeType: tradeType, stock: stock, tradeHistory: tradeHistory)
    }
}
