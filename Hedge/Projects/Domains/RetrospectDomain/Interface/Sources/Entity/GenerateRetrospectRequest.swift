//
//  GenerateRetrospectRequest.swift
//  ReprospectDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

// MARK: - GenerateRetrospectRequest
public struct GenerateRetrospectRequest {
    public let symbol: String
    public let market: String
    public let orderType: OrderType
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double
    public let content: String
    public let principleChecks: [PrincipleCheck]
    public let emotion: Emotion
    
    public init(
        symbol: String,
        market: String,
        orderType: OrderType,
        price: Int,
        currency: String,
        volume: Int,
        orderDate: String,
        returnRate: Double,
        content: String,
        principleChecks: [PrincipleCheck],
        emotion: Emotion
    ) {
        self.symbol = symbol
        self.market = market
        self.orderType = orderType
        self.price = price
        self.currency = currency
        self.volume = volume
        self.orderDate = orderDate
        self.returnRate = returnRate
        self.content = content
        self.principleChecks = principleChecks
        self.emotion = emotion
    }
}

// MARK: - OrderType
public enum OrderType: String {
    case buy = "BUY"
    case sell = "SELL"
}

// MARK: - PrincipleCheck
public struct PrincipleCheck {
    public let principleId: Int
    public let isFollowed: Bool
    
    public init(principleId: Int, isFollowed: Bool) {
        self.principleId = principleId
        self.isFollowed = isFollowed
    }
}

// MARK: - Emotion
public enum Emotion: String {
    case confidence = "CONFIDENCE"
    case conviction = "CONVICTION"
    case neutral = "MINDLESSNESS"
    case impulse = "IMPULSE"
    case anxious = "ANXIOUS"
}
