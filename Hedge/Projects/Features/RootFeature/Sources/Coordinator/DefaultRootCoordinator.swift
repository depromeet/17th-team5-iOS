//
//  DefaultRootCoordinator.swift
//  RootFeature
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import UIKit
import SwiftUI

import ComposableArchitecture

import Core
import Shared
import StockSearchFeature
import StockSearchFeatureInterface
import TradeHistoryFeature
import TradeHistoryFeatureInterface
import PrinciplesFeature
import PrinciplesFeatureInterface
import StockDomainInterface
import TradeFeedbackFeature
import TradeFeedbackFeatureInterface
import PrinciplesDomainInterface
import PrincipleReviewFeature
import FeedbackDomainInterface
import SettingFeature
import SettingFeatureInterface
import RetrospectionFeature
import RetrospectionFeatureInterface
import PrincipleDetailFeature
import PrincipleDetailFeatureInterface

public final class DefaultRootCoordinator: RootCoordinator {
    
    public var navigationController: UINavigationController
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public var type: Core.CoordinatorType = .root
    
    public var childCoordinators: [Coordinator] = [] {
        didSet {
            Log.debug("\(childCoordinators)")
        }
    }
    
    // Weak reference to TabBarFeature store to send actions
    weak var tabBarStore: StoreOf<TabBarFeature>?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let store = StoreOf<TabBarFeature>(
            initialState: TabBarFeature.State(),
            reducer: {
                TabBarFeature(coordinator: self)
            }
        )
        self.tabBarStore = store
        
        let tabView = TabBarView(store: store)
        let viewController = UIHostingController(rootView: tabView)
        navigationController.viewControllers = [viewController]
        // App starts with home screen (no initial navigation needed)
    }
    
    public func pushToStockSearch(with tradeType: TradeType) {
        let stockSearchCoordinator = DefaultStockSearchCoordinator(
            navigationController: self.navigationController,
            tradeType: tradeType
        )
        stockSearchCoordinator.parentCoordinator = self
        stockSearchCoordinator.finishDelegate = self
        stockSearchCoordinator.start()
        
        childCoordinators.append(stockSearchCoordinator)
    }
}

extension DefaultRootCoordinator {
    public func pushToTradeHistory(
        tradeType: TradeType,
        stock: StockSearch
    ) {
        let tradeHistoryCoordinator = DefaultTradeHistoryCoordinator(
            navigationController: navigationController,
            tradeType: tradeType,
            stockSearch: stock
        )
        tradeHistoryCoordinator.parentCoordinator = self
        tradeHistoryCoordinator.finishDelegate = self
        tradeHistoryCoordinator.start()
        
        childCoordinators.append(tradeHistoryCoordinator)
    }
    
    public func pushToPrinciples(
        tradeType: TradeType,
        stock: StockSearch,
        tradeHistory: TradeHistory
    ) {
        
        let principlesCoordinator = DefaultPrinciplesCoordinator(
            navigationController: navigationController,
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory
        )
        principlesCoordinator.parentCoordinator = self
        principlesCoordinator.principleDelegate = self
        principlesCoordinator.start()
        
        childCoordinators.append(principlesCoordinator)
    }
    
    public func pushToFeedback(feedback: FeedbackData) {
        let tradeFeedbackCoordinator = DefaultTradeFeedbackCoordinator(
            navigationController: self.navigationController,
            feedback: feedback
        )
        tradeFeedbackCoordinator.parentCoordinator = self
        tradeFeedbackCoordinator.finishDelegate = self
        tradeFeedbackCoordinator.start()
        
        childCoordinators.append(tradeFeedbackCoordinator)
        Log.debug("📱 RootCoordinator: TradeFeedbackCoordinator started and pushed to navigation stack")
    }
    
    public func pushToPrinciplesReview(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, group: PrincipleGroup) {
        let principleReviewCoordinator = DefaultPrincipleReviewCoordinator(
            navigationController: self.navigationController,
            tradeType: tradeType,
            stock: stock,
            tradeHistory: tradeHistory,
            principleGroup: group
        )
        
        principleReviewCoordinator.parentCoordinator = self
        principleReviewCoordinator.finishDelegate = self
        principleReviewCoordinator.start()
        
        childCoordinators.append(principleReviewCoordinator)
    }
    
    public func popToHome() {
        navigationController.popToRootViewController(animated: false)
        childCoordinators.removeAll()
    }
    
    public func pushToSetting() {
        let settingCoordinator = DefaultSettingCoordinator(navigationController: navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.parentCoordinator = self
        
        childCoordinators.append(settingCoordinator)
        
        settingCoordinator.start()
    }
    
    public func pushToRetrospection(_ id: Int) {
        let retrospectionCoordinator = DefaultRetrospectionCoordinator(navigationController: navigationController, retrospectionId: id)
        retrospectionCoordinator.finishDelegate = self
        retrospectionCoordinator.parentCoordinator = self
        
        childCoordinators.append(retrospectionCoordinator)
        
        retrospectionCoordinator.start()
    }
    
    public func pushToPrincipleDetail(principleGroup: PrincipleGroup, isRecommended: Bool) {
        let principleDetailCoordinator = DefaultPrincipleDetailCoordinator(
            navigationController: navigationController,
            principleGroup: principleGroup,
            isRecommended: isRecommended
        )
        principleDetailCoordinator.finishDelegate = self
        principleDetailCoordinator.parentCoordinator = self
        principleDetailCoordinator.principleDetailDelegate = self
        
        childCoordinators.append(principleDetailCoordinator)
        
        principleDetailCoordinator.start()
    }
    
    public func signOut() {
        self.childCoordinators.removeAll()
        self.finish()
    }
}

extension DefaultRootCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Core.Coordinator) {
        Log.debug("Coordinator Finish : \(childCoordinator)")
        
        self.childCoordinators.removeAll{ $0.type == childCoordinator.type }
        
        navigationController.popViewController(animated: true)
    }
}

extension DefaultRootCoordinator: PrincipleDelegate {
    public func choosePrincipleGroup(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, group: PrincipleGroup) {

        pushToPrinciplesReview(tradeType: tradeType, stock: stock, tradeHistory: tradeHistory, group: group)
    }
}

extension DefaultRootCoordinator: PrincipleDetailCoordinatorDelegate {
    public func switchToPrincipleTab() {
        // 홈 화면 탭을 원칙 탭으로 변경
        guard let tabBarStore = tabBarStore else {
            Log.error("tabBarStore is nil")
            return
        }
        // homeState가 nil이면 생성
        if tabBarStore.state.homeState == nil {
            tabBarStore.send(.view(.onAppear))
            // homeState 생성 후 action 전달을 위해 약간의 딜레이
            DispatchQueue.main.async {
                tabBarStore.send(.delegate(.homeAction(.view(.principleTabTapped))))
            }
        } else {
            tabBarStore.send(.delegate(.homeAction(.view(.principleTabTapped))))
        }
    }
    
    public func switchToPrincipleTabAndShowToast() {
        // 홈 화면 탭을 원칙 탭으로 변경
        guard let tabBarStore = tabBarStore else {
            Log.error("tabBarStore is nil")
            return
        }
        
        tabBarStore.send(.delegate(.homeAction(.view(.principleTabTapped))))
        tabBarStore.send(.delegate(.homeAction(.view(.showPrincipleCreatedToast))))
    }
}
