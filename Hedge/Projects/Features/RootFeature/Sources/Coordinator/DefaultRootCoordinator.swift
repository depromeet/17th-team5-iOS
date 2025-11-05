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
import Shared
import StockSearchFeature
import StockSearchFeatureInterface
import TradeHistoryFeature
import TradeHistoryFeatureInterface
import TradeReasonFeature
import TradeReasonFeatureInterface
import PrinciplesFeature
import PrinciplesFeatureInterface
import StockDomainInterface
import TradeFeedbackFeature
import TradeFeedbackFeatureInterface
import PrinciplesDomainInterface

public final class DefaultRootCoordinator: RootCoordinator {
    
    public var navigationController: UINavigationController
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public var type: Core.CoordinatorType = .root
    
    public var childCoordinators: [Coordinator] = [] {
        didSet {
            Log.debug("\(childCoordinators)")
        }
    }
    
    // Weak reference to TabBarFeature store to send actions
    weak var tabBarStore: StoreOf<TabBarFeature>?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let store = StoreOf<TabBarFeature>(
            initialState: TabBarFeature.State(),
            reducer: {
                TabBarFeature(coordinator: self)
            }
        )
        self.tabBarStore = store
        
        let tabView = TabBarView(store: store)
        let viewController = UIHostingController(rootView: tabView)
        navigationController.viewControllers = [viewController]
        // App starts with home screen (no initial navigation needed)
    }
    
    public func pushToStockSearch(with tradeType: TradeType) {
        let stockSearchCoordinator = DefaultStockSearchCoordinator(
            navigationController: self.navigationController,
            tradeType: tradeType
        )
        stockSearchCoordinator.parentCoordinator = self
        stockSearchCoordinator.finishDelegate = self
        stockSearchCoordinator.start()
        
        childCoordinators.append(stockSearchCoordinator)
    }
}

extension DefaultRootCoordinator {
    public func pushToTradeHistory(
        tradeType: TradeType,
        stock: StockSearch
    ) {
        let tradeHistoryCoordinator = DefaultTradeHistoryCoordinator(
            navigationController: navigationController,
            tradeType: tradeType,
            stockSearch: stock
        )
        tradeHistoryCoordinator.parentCoordinator = self
        tradeHistoryCoordinator.finishDelegate = self
        tradeHistoryCoordinator.start()
        
        childCoordinators.append(tradeHistoryCoordinator)
    }
    
    public func pushToPrinciples(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory
    ) {
        // let principlesCoordinator = DefaultPrinciplesCoordinator(
        //     navigationController: navigationController,
        //     tradeType: tradeType,
        //     stock: stock,
        //     tradeHistory: tradeHistory,
        //     viewBuilder: PrinciplesViewBuilder()
        // )
        // principlesCoordinator.parentCoordinator = self
        // principlesCoordinator.finishDelegate = self
        // principlesCoordinator.start()
        // 
        // childCoordinators.append(principlesCoordinator)
    }
    
    public func showEmotionSelection(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory
    ) {
        // let principlesCoordinator = DefaultPrinciplesCoordinator(
        //     navigationController: navigationController,
        //     tradeType: tradeType,
        //     stock: stock,
        //     tradeHistory: tradeHistory
        // )
        // principlesCoordinator.parentCoordinator = self
        // principlesCoordinator.start()
    }
    
    public func pushToFeedback(tradeData: TradeData) {
        Log.debug("📱 RootCoordinator: Creating TradeFeedbackCoordinator for trade ID: \(tradeData.id)")
        let tradeFeedbackCoordinator = DefaultTradeFeedbackCoordinator(
            navigationController: self.navigationController,
            tradeData: tradeData
        )
        tradeFeedbackCoordinator.parentCoordinator = self
        tradeFeedbackCoordinator.finishDelegate = self
        tradeFeedbackCoordinator.start()
        
        childCoordinators.append(tradeFeedbackCoordinator)
        Log.debug("📱 RootCoordinator: TradeFeedbackCoordinator started and pushed to navigation stack")
    }
    
    public func popToHome(selectingStock stockSymbol: String) {
        // Pop all view controllers until we reach the root (home screen)
        navigationController.popToRootViewController(animated: true)
        
        // Remove finished coordinators
        childCoordinators.removeAll { $0.type == .tradeFeedback }
        
        // Delay sending action to ensure navigation animation completes and view is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, let store = self.tabBarStore else { return }
            store.send(.delegate(.homeAction(.view(.stockSelected(stockSymbol)))))
        }
    }
}

extension DefaultRootCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Core.Coordinator) {
        Log.debug("Coordinator Finish : \(childCoordinator)")
        
        self.childCoordinators.removeAll{ $0.type == childCoordinator.type }
        
        navigationController.popViewController(animated: true)
    }
}
