//
//  FeedbackData.swift
//  FeedbackDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct FeedbackData: Equatable {
    public let symbol: String
    public let price: Int
    public let volume: Int
    public let orderType: String
    public let keptCount: Int
    public let neutralCount: Int
    public let notKeptCount: Int
    public let badge: String
    public let keep: [String]
    public let fix: [String]
    public let next: [String]
    
    public init(
        symbol: String,
        price: Int,
        volume: Int,
        orderType: String,
        keptCount: Int,
        neutralCount: Int,
        notKeptCount: Int,
        badge: String,
        keep: [String],
        fix: [String],
        next: [String]
    ) {
        self.symbol = symbol
        self.price = price
        self.volume = volume
        self.orderType = orderType
        self.keptCount = keptCount
        self.neutralCount = neutralCount
        self.notKeptCount = notKeptCount
        self.badge = badge
        self.keep = keep
        self.fix = fix
        self.next = next
    }
}
