//
//  DefaultRetrospectCoordinator.swift
//  RetrospectFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import RetrospectFeatureInterface
import StockDomainInterface

public final class DefaultRetrospectCoordinator: RetrospectCoordinator {
    public var navigationController: UINavigationController
    
    public var childCoordinators: [Coordinator] = []
    public var parentCoordinator: RootCoordinator?
    
    public var tradeDataBuilder: TradeDataBuilder
    
    public init(navigationController: UINavigationController, tradeDataBuilder: TradeDataBuilder) {
        self.navigationController = navigationController
        self.tradeDataBuilder = tradeDataBuilder
    }
    
    public func start() {
        let retrospectView = RetrospectSearchView(
            store: .init(
                initialState: RetrospectSearchFeature.State(),
                reducer: {
                    RetrospectSearchFeature(
                        coordinator: self
                    )
                }
            )
        )
        
        let retrospectViewController = UIHostingController(rootView: retrospectView)
        
        navigationController.pushViewController(
            retrospectViewController,
            animated: true
        )
    }
    
    public func popToPrev() {
        navigationController.popViewController(animated: true)
    }
    
    public func pushToTradeHistory(stock: StockSearch) {
        parentCoordinator?.pushToTradeHistory(stock: stock)
    }
}
