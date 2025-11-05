//
//  TradeData.swift
//  Core
//
//  Created by 이중엽 on 9/25/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface

public struct TradeData: Identifiable, Equatable, Codable {
    private let uuid = UUID()
    
    public var id: Int
    public var tradeType: TradeType
    public var stockSymbol: String
    public var stockTitle: String
    public var stockMarket: String
    public var tradingPrice: String
    public var tradingQuantity: String
    public var tradingDate: String
    public var yield: String?
    public var tradePrinciple: [Principle]
    public var retrospection: String
    
    // Exclude uuid from Codable encoding/decoding
    private enum CodingKeys: String, CodingKey {
        case id, tradeType, stockSymbol, stockTitle, stockMarket,
             tradingPrice, tradingQuantity, tradingDate, yield,
             tradePrinciple, retrospection
    }
    
    public init(
        id: Int,
        tradeType: TradeType,
        stockSymbol: String,
        stockTitle: String,
        stockMarket: String,
        tradingPrice: String,
        tradingQuantity: String,
        tradingDate: String,
        yield: String? = nil,
        tradePrinciple: [Principle],
        retrospection: String
    ) {
        self.id = id
        self.tradeType = tradeType
        self.stockSymbol = stockSymbol
        self.stockTitle = stockTitle
        self.stockMarket = stockMarket
        self.tradingPrice = tradingPrice
        self.tradingQuantity = tradingQuantity
        self.tradingDate = tradingDate
        self.yield = yield
        self.tradePrinciple = tradePrinciple
        self.retrospection = retrospection
    }
    
    public static func == (lhs: TradeData, rhs: TradeData) -> Bool {
        lhs.id == rhs.id
    }
}
