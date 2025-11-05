//
//  TradeData.swift
//  Core
//
//  Created by 이중엽 on 9/25/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface

/// Trade data model representing a single trade retrospective
/// Conforms to Identifiable for SwiftUI list usage
/// uuid is excluded from Codable encoding/decoding to avoid persistence issues
/// Equatable compares by `id` only (not uuid) to ensure stability across app launches
public struct TradeData: Identifiable, Equatable, Codable {
    // UUID for internal identity only, excluded from Codable and Equatable
    // After decoding, a new uuid is generated, so we use `id` for equality
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
    public var emotion: TradeEmotion?
    public var tradePrinciple: [Principle]
    public var retrospection: String
    
    // Exclude uuid from Codable encoding/decoding
    private enum CodingKeys: String, CodingKey {
        case id, tradeType, stockSymbol, stockTitle, stockMarket,
             tradingPrice, tradingQuantity, tradingDate, yield,
             emotion, tradePrinciple, retrospection
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
        emotion: TradeEmotion? = nil,
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
        self.emotion = emotion
        self.tradePrinciple = tradePrinciple
        self.retrospection = retrospection
    }
    
    // Custom Equatable implementation: compare by `id` only (not uuid)
    // This ensures equality is stable across app launches even though uuid changes after decoding
    public static func == (lhs: TradeData, rhs: TradeData) -> Bool {
        lhs.id == rhs.id
    }
}
