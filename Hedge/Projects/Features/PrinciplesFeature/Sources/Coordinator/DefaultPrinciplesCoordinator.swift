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
import PrinciplesDomainInterface

public final class DefaultPrinciplesCoordinator: PrinciplesCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var parentCoordinator: RootCoordinator?
    
    private let tradeType: TradeType
    private let stock: StockSearch
    private let tradeHistory: TradeHistory
    
    public init(navigationController: UINavigationController, tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory) {
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
    }
    
    public func start() {
            let principlesView = PrinciplesContainerView(
                store: .init(
                    initialState: PrinciplesFeature.State(tradeType: tradeType, stock: stock, tradeHistory: tradeHistory),
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
    
    public func pushToTradeReason(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, tradePrinciple: [Principle], selectedPrinciples: Set<Int>) {
        
        // Navigate to TradeReason using parent coordinator
        if let parent = parentCoordinator {
            parent.pushToTradeReason(
                tradeType: tradeType,
                stock: stock,
                tradeHistory: tradeHistory,
                tradePrinciple: tradePrinciple,
                selectedPrinciples: selectedPrinciples
            )
        } else {
            print("   ❌ ERROR: parentCoordinator is nil!")
        }
    }
}
