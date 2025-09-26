//
//  DefaultTradeReasonCoordinator.swift
//  TradeReasonFeature
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import Core
import TradeReasonFeatureInterface
import StockDomainInterface

public final class DefaultTradeReasonCoordinator: TradeReasonCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var parentCoordinator: RootCoordinator?
    
    private let tradeType: TradeType
    private let stock: StockSearch
    private let tradingPrice: String
    private let tradingQuantity: String
    private let tradingDate: String
    private let yield: String
    
    public init(navigationController: UINavigationController, tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String) {
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradingPrice = tradingPrice
        self.tradingQuantity = tradingQuantity
        self.tradingDate = tradingDate
        self.yield = yield
    }
    
    public func start() {
        let tradeReasonInputView = TradeReasonInputView(
            store: .init(
                initialState: TradeReasonFeature.State(tradeType: tradeType, stock: stock, tradingPrice: tradingPrice, tradingQuantity: tradingQuantity, tradingDate: tradingDate, yield: yield),
                reducer: {
                    TradeReasonFeature(coordinator: self)
                }
            )
        )
        
        let viewController = UIHostingController(rootView: tradeReasonInputView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func popToPrev() {
        navigationController.popViewController(animated: true)
    }
    
    public func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String) {
        parentCoordinator?.pushToPrinciples(tradeType: tradeType, stock: stock, tradingPrice: tradingPrice, tradingQuantity: tradingQuantity, tradingDate: tradingDate, yield: yield, reasonText: reasonText)
    }
    
    public func showEmotionSelection(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String) {
        parentCoordinator?.showEmotionSelection(tradeType: tradeType, stock: stock, tradingPrice: tradingPrice, tradingQuantity: tradingQuantity, tradingDate: tradingDate, yield: yield, reasonText: reasonText)
    }
}
