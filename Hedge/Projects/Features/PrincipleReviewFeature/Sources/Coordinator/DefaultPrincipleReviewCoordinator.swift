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
import PrincipleReviewFeatureInterface
import PrinciplesDomainInterface
import PrinciplesDomain
import StockDomainInterface
import Shared

public final class DefaultPrincipleReviewCoordinator: PrinciplesReviewCoordinator {
    
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
        
    }
    
    public func popToProv() {
        <#code#>
    }
}
