//
//  TradeHistoryCoordinator.swift
//  TradeHistoryFeature
//
//  Created by Junyoung on 9/24/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
import Core
import StockDomainInterface

public protocol TradeHistoryCoordinator: Coordinator {
    func popToPrev()
    func pushToPrinciples(tradeType: TradeType, stock: StockSearch, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String, reasonText: String)
}
