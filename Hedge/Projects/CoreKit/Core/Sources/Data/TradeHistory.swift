//
//  TradeHistory.swift
//  Core
//
//  Created by 이중엽 on 9/24/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct TradeHistory {
    public var tradingPrice: String
    public var tradingQuantity: String
    public var tradingDate: String
    public var yield: String?
    
    public init(tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String? = nil) {
        self.tradingPrice = tradingPrice
        self.tradingQuantity = tradingQuantity
        self.tradingDate = tradingDate
        self.yield = yield
    }
}
