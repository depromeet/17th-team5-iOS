//
//  Feedback.swift
//  Core
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct Feedback: Equatable {
    
    public static func == (lhs: Feedback, rhs: Feedback) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public let uuid: UUID = UUID()
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
    
    public static func mock() -> Self {
        Feedback(
            symbol: "005930",
            price: 10000,
            volume: 10,
            orderType: "BUY",
            keptCount: 2,
            neutralCount: 1,
            notKeptCount: 1,
            badge: "감각의 전성기",
            keep: ["시장 흐름을 잘 읽고 판단했어요."],
            fix: ["근거를 조금 더 정리해 보세요."],
            next: ["비슷한 상황에서도 침착하게 대응해 보세요."]
        )
    }
}
