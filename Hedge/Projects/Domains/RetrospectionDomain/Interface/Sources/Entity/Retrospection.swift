//
//  Retrospection.swift
//  RetrospectionDomain
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

public struct Retrospection: Equatable, Hashable {
    public let id: Int
    public let orderType: String // BUY or SELL
    public let price: Int
    public let volume: Int
    public let retrospectionCreatedAt: String
    public let orderCreatedAt: String
    
    public init(
        id: Int,
        orderType: String,
        price: Int,
        volume: Int,
        retrospectionCreatedAt: String,
        orderCreatedAt: String
    ) {
        self.id = id
        self.orderType = orderType
        self.price = price
        self.volume = volume
        self.retrospectionCreatedAt = retrospectionCreatedAt
        self.orderCreatedAt = orderCreatedAt
    }
}
