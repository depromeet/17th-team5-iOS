//
//  TradeReasonCoordinator.swift
//  TradeReasonFeatureInterface
//
//  Created by 이중엽 on 9/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import Core
import StockDomainInterface

public protocol TradeReasonCoordinator: Coordinator {
    func popToPrev()
    func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory)
    func showEmotionSelection(tradeType: TradeType, stock: StockSearch, tradeHistory: TradeHistory)
    func pushToFeedback(tradeData: TradeData)
}
