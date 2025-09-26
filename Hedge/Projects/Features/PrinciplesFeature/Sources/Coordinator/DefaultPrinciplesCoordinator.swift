//
//  DefaultPrinciplesCoordinator.swift
//  PrinciplesFeature
//
//  Created by Dongjoo Lee on 9/23/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import Core
import PrinciplesFeatureInterface
import StockDomainInterface

public final class DefaultPrinciplesCoordinator: PrinciplesCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var parentCoordinator: RootCoordinator?
    
    private let tradeType: TradeType
    private let stock: StockSearch
    private let tradingPrice: String
    private let tradingQuantity: String
    private let tradingDate: String
    private let yield: String
    private let reasonText: String
    
    public init(navigationController: UINavigationController, tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String) {
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradingPrice = tradingPrice
        self.tradingQuantity = tradingQuantity
        self.tradingDate = tradingDate
        self.yield = yield
        self.reasonText = reasonText
    }
    
    public func start() {
            let principlesView = PrinciplesView(
                store: .init(
                    initialState: PrinciplesFeature.State(tradeType: tradeType, stock: stock, tradingPrice: tradingPrice, tradingQuantity: tradingQuantity, tradingDate: tradingDate, yield: yield, reasonText: reasonText),
                    reducer: {
                        PrinciplesFeature(coordinator: self)
                    }
                )
            )
        
        let viewController = UIHostingController(rootView: principlesView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func popToPrev() {
        navigationController.popViewController(animated: true)
    }
    
    public func pushToTradeReason(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, emotion: TradeEmotion, tradePrinciple: [String]) {
        // Print the trade data being passed
        print("🚀 Navigating to TradeReason with data:")
        print("   TradeType: \(tradeType.rawValue)")
        print("   Stock: \(stock.title) (\(stock.symbol))")
        print("   Price: \(tradingPrice)")
        print("   Quantity: \(tradingQuantity)")
        print("   Date: \(tradingDate)")
        print("   Yield: \(yield)")
        print("   Emotion: \(emotion)")
        print("   Principles: \(tradePrinciple)")
        print("   Parent coordinator: \(parentCoordinator != nil ? "✅ Set" : "❌ NIL")")
        
        // Navigate to TradeReason using parent coordinator
        if let parent = parentCoordinator {
            print("   Calling parent.pushToTradeReason...")
            parent.pushToTradeReason(
                tradeType: tradeType,
                stock: stock,
                tradingPrice: tradingPrice,
                tradingQuantity: tradingQuantity,
                tradingDate: tradingDate,
                yield: yield,
                emotion: emotion,
                tradePrinciple: tradePrinciple
            )
        } else {
            print("   ❌ ERROR: parentCoordinator is nil!")
        }
    }
}
