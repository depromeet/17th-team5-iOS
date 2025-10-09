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
    
    public func pushToStockSearch(with tradeType: TradeType) {
        let stockSearchCoordinator = DefaultStockSearchCoordinator(
            navigationController: self.navigationController,
            tradeType: tradeType
        )
        stockSearchCoordinator.parentCoordinator = self
        stockSearchCoordinator.start()
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
    
    public func pushToTradeReason(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, emotion: TradeEmotion, tradePrinciple: [String]) {
        print("🎯 RootCoordinator.pushToTradeReason called!")
        print("   TradeType: \(tradeType.rawValue)")
        print("   Stock: \(stock.title) (\(stock.symbol))")
        print("   Emotion: \(emotion)")
        print("   Principles: \(tradePrinciple)")
        
        let tradeReasonCoordinator = DefaultTradeReasonCoordinator(
            navigationController: navigationController,
            tradeType: tradeType,
            stock: stock,
            tradingPrice: tradingPrice,
            tradingQuantity: tradingQuantity,
            tradingDate: tradingDate,
            yield: yield
        )
        tradeReasonCoordinator.parentCoordinator = self
        tradeReasonCoordinator.start()
        print("   ✅ TradeReasonCoordinator started")
    }
    
    public func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String) {
        let principlesCoordinator = DefaultPrinciplesCoordinator(
            navigationController: navigationController,
            tradeType: tradeType,
            stock: stock,
            tradingPrice: tradingPrice,
            tradingQuantity: tradingQuantity,
            tradingDate: tradingDate,
            yield: yield,
            reasonText: reasonText
        )
        principlesCoordinator.parentCoordinator = self
        principlesCoordinator.start()
    }
    
    public func showEmotionSelection(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String) {
        // For now, just navigate to principles with emotion selection
        // This will show the emotion selection bottom sheet first
        let principlesCoordinator = DefaultPrinciplesCoordinator(
            navigationController: navigationController,
            tradeType: tradeType,
            stock: stock,
            tradingPrice: tradingPrice,
            tradingQuantity: tradingQuantity,
            tradingDate: tradingDate,
            yield: yield,
            reasonText: reasonText
        )
        principlesCoordinator.parentCoordinator = self
        principlesCoordinator.start()
    }
    
    public func pushToFeedback(tradeData: TradeData) {
        let tradeFeedbackCoordinator = DefaultTradeHFeedbackCoordinator(
            navigationController: self.navigationController,
            tradeData: tradeData
        )
        tradeFeedbackCoordinator.parentCoordinator = self
        tradeFeedbackCoordinator.start()
    }
}
