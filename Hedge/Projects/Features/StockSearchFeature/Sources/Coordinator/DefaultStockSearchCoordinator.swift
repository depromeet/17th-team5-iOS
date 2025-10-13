//
//  DefaultStockSearchCoordinator.swift
//  StockSearchFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import StockSearchFeatureInterface
import StockDomainInterface

public final class DefaultStockSearchCoordinator: StockSearchCoordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .stockSearch
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    public var tradeType: TradeType
    
    public init(navigationController: UINavigationController, tradeType: TradeType) {
        self.navigationController = navigationController
        self.tradeType = tradeType
    }
    
    public func start() {
        let stockSearchView = StockSearchView(
            store: .init(
                initialState: StockSearchFeature.State(),
                reducer: {
                    StockSearchFeature(
                        coordinator: self,
                        tradeType: tradeType
                    )
                }
            )
        )
        
        let stockSearchViewController = UIHostingController(rootView: stockSearchView)
        
        navigationController.pushViewController(
            stockSearchViewController,
            animated: true
        )
    }
    
    public func popToPrev() {
        finish()
    }
    
    public func pushToTradeHistory(tradeType: TradeType, stock: StockSearch) {
        parentCoordinator?.pushToTradeHistory(tradeType: tradeType, stock: stock)
    }
}
