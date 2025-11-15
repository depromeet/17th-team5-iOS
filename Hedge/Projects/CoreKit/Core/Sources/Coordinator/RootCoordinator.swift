//
//  RootCoordinator.swift
//  Core
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import StockDomainInterface
import PrinciplesDomainInterface
import FeedbackDomainInterface

public protocol RootCoordinator: Coordinator {
    func pushToStockSearch(with tradeType: TradeType)
    func pushToTradeHistory(tradeType: TradeType, stock: StockSearch)
    func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory)
    func pushToPrinciplesReview(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, group: PrincipleGroup)
    func pushToFeedback(feedback: FeedbackData)
    func pushToPrincipleDetail(principleGroup: PrincipleGroup, isRecommended: Bool)
    func popToHome()
    func pushToSetting()
    func pushToRetrospection(_ id: Int)
    func signOut()
}
