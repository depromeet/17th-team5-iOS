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
    func pushToSelectPrinciple(title: String, id: Int, recommendedPrinciples: [String])
    func pushToFeedback(tradeType: TradeType, stock: StockSearch, tradeHistory: Core.TradeHistory, feedback: FeedbackData)
    func popToHome()
    func pushToSetting()
    func signOut()
}
