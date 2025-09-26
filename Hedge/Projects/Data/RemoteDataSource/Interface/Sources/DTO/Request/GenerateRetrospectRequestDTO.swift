//
//  GenerateRetrospectRequestDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

// MARK: - GenerateRetrospectRequest
public struct GenerateRetrospectRequestDTO: Encodable {
    public let symbol: String
    public let market: String
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double
    public let content: String
    public let principleChecks: [PrincipleCheckRequestDTO]
    public let emotion: String
    
    public init(
        symbol: String,
        market: String,
        orderType: String,
        price: Int,
        currency: String,
        volume: Int,
        orderDate: String,
        returnRate: Double,
        content: String,
        principleChecks: [PrincipleCheckRequestDTO],
        emotion: String
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

// MARK: - PrincipleCheck
public struct PrincipleCheckRequestDTO: Encodable, Equatable {
    public let principleId: Int
    public let isFollowed: Bool
    
    public init(
        principleId: Int,
        isFollowed: Bool
    ) {
        self.principleId = principleId
        self.isFollowed = isFollowed
    }
}
