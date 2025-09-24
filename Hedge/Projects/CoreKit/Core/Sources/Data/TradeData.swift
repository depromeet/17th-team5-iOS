//
//  TradeData.swift
//  Core
//
//  Created by 이중엽 on 9/25/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct TradeData: Equatable {
    private let uuid: UUID = UUID()
    public var tradeType: TradeType
    public var stockSymbol: String
    public var stockTitle: String
    public var stockMarket: String
    public var tradingPrice: String
    public var tradingQuantity: String
    public var tradingDate: String
    public var yield: String?
    public var emotion: TradeEmotion?
    public var tradePrinciple: [String]
    public var retrospection: String
    
    public init(tradeType: TradeType, stockSymbol: String, stockTitle: String, stockMarket: String, tradingPrice: String, tradingQuantity: String, tradingDate: String, yield: String? = nil, emotion: TradeEmotion? = nil, tradePrinciple: [String], retrospection: String) {
        self.tradeType = tradeType
        self.stockSymbol = stockSymbol
        self.stockTitle = stockTitle
        self.stockMarket = stockMarket
        self.tradingPrice = tradingPrice
        self.tradingQuantity = tradingQuantity
        self.tradingDate = tradingDate
        self.yield = yield
        self.emotion = emotion
        self.tradePrinciple = tradePrinciple
        self.retrospection = retrospection
    }
}
