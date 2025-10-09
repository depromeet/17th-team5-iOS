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
import Shared
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
    private let viewBuilder: PrinciplesViewBuilderProtocol
    private let fetchPrinciplesUseCase = DIContainer.resolve(FetchPrinciplesUseCase.self)
    
    public init(
        navigationController: UINavigationController,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        viewBuilder: PrinciplesViewBuilderProtocol
    ) {
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.viewBuilder = viewBuilder
    }
    
    public func start() {
        let principlesContainerView = viewBuilder.build(
            coordinator: self,
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory,
            fetchPrinciplesUseCase: fetchPrinciplesUseCase
        )
        
        let viewController = UIHostingController(rootView: AnyView(principlesContainerView))
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
