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
import PrinciplesDomainInterface
import PrinciplesDomain
import StockDomainInterface
import Shared

public final class DefaultPrinciplesCoordinator: PrinciplesCoordinator {
    
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType = .principles
    public weak var parentCoordinator: RootCoordinator?
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var principleDelegate: PrincipleDelegate?
    
    public var tradeType: TradeType
    public var stock: StockSearch
    public var tradeHistory: TradeHistory
    
    public init(navigationController: UINavigationController, tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory) {
        self.navigationController = navigationController
        self.tradeType = tradeType
        self.stock = stock
        self.tradeHistory = tradeHistory
    }
    
    public func start() {
        
        let principlesView = PrinciplesView(
                store: Store(
                    initialState: PrinciplesFeature.State(viewType: .select),
                    reducer: {
                        PrinciplesFeature(
                            coordinator: self,
                            fetchPrinciplesUseCase: DIContainer.resolve(FetchPrinciplesUseCase.self),
                            tradeType: tradeType,
                            stock: stock,
                            tradeHistory: tradeHistory
                        )
                    }
                )
            )
            
            let principlesViewController = UIHostingController(rootView: principlesView)
            navigationController.present(principlesViewController, animated: true)
    }
    
    public func dismiss(animated: Bool) {
        childCoordinators.removeAll()
        parentCoordinator?.childCoordinators.removeAll{ $0.type == .principles }
        navigationController.dismiss(animated: animated)
    }
}
