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

public protocol RootCoordinator: Coordinator {
    func pushToStockSearch(with tradeType: TradeType)
    func pushToTradeHistory(tradeType: TradeType, stock: StockSearch)
    func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory)
    func pushToPrinciplesReview(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory, group: PrincipleGroup)
    func pushToFeedback(tradeData: TradeData)
    func popToHome(selectingStock stockSymbol: String)
    func pushToSetting()
    func signOut()
}
