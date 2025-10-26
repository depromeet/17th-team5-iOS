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
import AnalysisDomainInterface
import PrinciplesFeatureInterface

public final class DefaultTradeReasonCoordinator: TradeReasonCoordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .tradeReason
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
    private let tradeType: TradeType
    private let stock: StockSearch
    private let tradeHistory: TradeHistory
    private let principles: [Principle]
    private let selectedPrinciples: Set<Int>
    private let principleBuilder: PrinciplesViewBuilderProtocol
    private let tradeReasonBuilder: TradeReasonViewBuilder
    private let generateRetrospectUseCase = DIContainer.resolve(GenerateRetrospectUseCase.self)
    private let analysisUseCase = DIContainer.resolve(AnalysisUseCase.self)
    
    public init(
        navigationController: UINavigationController,
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        principles: [Principle],
        selectedPrinciples: Set<Int>,
        principleBuilder: PrinciplesViewBuilderProtocol,
        tradeReasonBuilder: TradeReasonViewBuilder
    ) {
        
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
        self.principles = principles
        self.selectedPrinciples = selectedPrinciples
        self.principleBuilder = principleBuilder
        self.tradeReasonBuilder = tradeReasonBuilder
    }
    
    public func start() {
        let tradeReasonInputView = tradeReasonBuilder.build(
            coordinator: self,
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory,
            principles: principles,
            selectedPrinciples: selectedPrinciples,
            principleBuilder: principleBuilder,
            analysisUseCase: analysisUseCase,
            generateRetrospectUseCase: generateRetrospectUseCase
        )
        
        let viewController = UIHostingController(rootView: AnyView(tradeReasonInputView))
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func popToPrev() {
        finish()
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
