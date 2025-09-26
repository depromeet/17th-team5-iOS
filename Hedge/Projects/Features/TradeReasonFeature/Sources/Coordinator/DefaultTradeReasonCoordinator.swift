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
import RetrospectDomainInterface
import StockDomainInterface
import Shared
import PrinciplesDomainInterface

public final class DefaultTradeReasonCoordinator: TradeReasonCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var parentCoordinator: RootCoordinator?
    
    private let generateRetrospectUseCase = DIContainer.resolve(GenerateRetrospectUseCase.self)
    private let tradeType: TradeType
    private let stock: StockSearch
    private let tradeHistory: TradeHistory
    private let principles: [Principle]
    private let selectedPrinciples: Set<Int>
    
    public init(
        navigationController: UINavigationController,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        principles: [Principle],
        selectedPrinciples: Set<Int>
    ) {
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.principles = principles
        self.selectedPrinciples = selectedPrinciples
    }
    
    public func start() {
        let tradeReasonInputView = TradeReasonInputView(
            store: .init(
                initialState: TradeReasonFeature.State(tradeType: tradeType, stock: stock, tradeHistory: tradeHistory, principles: principles, selectedPrinciples: selectedPrinciples),
                reducer: {
                    TradeReasonFeature(
                        coordinator: self,
                        generateRetrospectUseCase: generateRetrospectUseCase
                    )
                }
            )
        )
        
        let viewController = UIHostingController(rootView: tradeReasonInputView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func popToPrev() {
        navigationController.popViewController(animated: true)
    }
    
    public func pushToPrinciples(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory
    ) {
        parentCoordinator?.pushToPrinciples(tradeType: tradeType, stock: stock, tradeHistory: tradeHistory)
    }
    
    public func showEmotionSelection(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory
    ) {
        parentCoordinator?.showEmotionSelection(tradeType: tradeType, stock: stock, tradeHistory: tradeHistory)
    }
    
    public func pushToFeedback(tradeData: TradeData) {
        parentCoordinator?.pushToFeedback(tradeData: tradeData)
    }
}
