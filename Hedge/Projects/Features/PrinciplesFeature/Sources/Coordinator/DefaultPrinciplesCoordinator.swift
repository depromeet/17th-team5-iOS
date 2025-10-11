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
    public var type: CoordinatorType = .principles
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    
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
        let principlesContainerView = viewBuilder.buildContainer(
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
        finish()
    }
    
    /// 매매 근거 기록하기 화면 이동
    public func pushToTradeReason(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory,
        tradePrinciple: [Principle],
        selectedPrinciples: Set<Int>
    ) {
        parentCoordinator?.pushToTradeReason(
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory,
            tradePrinciple: tradePrinciple,
            selectedPrinciples: selectedPrinciples
        )
    }
}
