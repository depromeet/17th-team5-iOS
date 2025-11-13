//
//  RetrospectionDetail.swift
//  RetrospectionDomainInterface
//
//  Created by Auto on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation
// import Core

public struct RetrospectionDetail: Equatable {
    public let id: Int
    public let userId: Int
    public let symbol: String
    public let market: String
    public let companyName: String
    public let companyLogo: String?
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double?
    public let badge: String
    public let principleCheckGroup: PrincipleCheckGroup
    public let memos: [Memo]
    public let createdAt: String
    public let updatedAt: String
    
    public init(
        id: Int,
        userId: Int,
        symbol: String,
        market: String,
        companyName: String,
        companyLogo: String?,
        orderType: String,
        price: Int,
        currency: String,
        volume: Int,
        orderDate: String,
        returnRate: Double?,
        badge: String,
        principleCheckGroup: PrincipleCheckGroup,
        memos: [Memo],
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.userId = userId
        self.symbol = symbol
        self.market = market
        self.companyName = companyName
        self.companyLogo = companyLogo
        self.orderType = orderType
        self.price = price
        self.currency = currency
        self.volume = volume
        self.orderDate = orderDate
        self.returnRate = returnRate
        self.badge = badge
        self.principleCheckGroup = principleCheckGroup
        self.memos = memos
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct PrincipleCheckGroup: Equatable {
    public let groupId: Int
    public let groupName: String
    public let thumbnail: String?
    public let principleType: String
    public let principleChecks: [PrincipleCheck]
    
    public init(
        groupId: Int,
        groupName: String,
        thumbnail: String?,
        principleType: String,
        principleChecks: [PrincipleCheck]
    ) {
        self.groupId = groupId
        self.groupName = groupName
        self.thumbnail = thumbnail
        self.principleType = principleType
        self.principleChecks = principleChecks
    }
}

public struct PrincipleCheck: Equatable {
    public let principleId: Int
    public let principle: String
    public let status: RetrospectionPrincipleStatus
    public let reason: String
    public let imageUrls: [String]
    public let links: [String]
    
    public init(
        principleId: Int,
        principle: String,
        status: RetrospectionPrincipleStatus,
        reason: String,
        imageUrls: [String],
        links: [String]
    ) {
        self.principleId = principleId
        self.principle = principle
        self.status = status
        self.reason = reason
        self.imageUrls = imageUrls
        self.links = links
    }
}

public struct Memo: Equatable {
    public let memoId: Int
    public let content: String
    public let createdAt: String
    
    public init(
        memoId: Int,
        content: String,
        createdAt: String
    ) {
        self.memoId = memoId
        self.content = content
        self.createdAt = createdAt
    }
}

