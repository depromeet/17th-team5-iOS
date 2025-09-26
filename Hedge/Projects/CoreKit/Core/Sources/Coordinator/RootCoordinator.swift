//
//  RootCoordinator.swift
//  Core
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import StockDomainInterface

public protocol RootCoordinator: Coordinator {
    func pushToStockSearch(with tradeType: TradeType)
    func pushToTradeHistory(tradeType: TradeType, stock: StockSearch)
    func pushToTradeReason(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String?, emotion: TradeEmotion, tradePrinciple: [String])
    func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String?, reasonText: String)
    func showEmotionSelection(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String?, reasonText: String)
    func pushToFeedback(tradeData: TradeData)
}
