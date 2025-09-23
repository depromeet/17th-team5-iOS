//
//  TradeData.swift
//  Core
//
//  Created by Junyoung on 9/14/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

// MARK: - TradeData
public struct TradeData: Equatable {
    public let type: TradeType
    public let quantity: Int
    public let stockName: String
    public let date: Date
    public let profitRate: Double?
    public let reason: String
    public let emotion: Emotion?
    
    public init(
        type: TradeType,
        quantity: Int,
        stockName: String,
        date: Date,
        profitRate: Double? = nil,
        reason: String,
        emotion: Emotion? = nil
    ) {
        self.type = type
        self.quantity = quantity
        self.stockName = stockName
        self.date = date
        self.profitRate = profitRate
        self.reason = reason
        self.emotion = emotion
    }
}

// MARK: - TradeType
public enum TradeType: String, CaseIterable, Equatable {
    case buy = "매수"
    case sell = "매도"
}

// MARK: - Emotion
public enum Emotion: String, CaseIterable, Equatable {
    case confident = "자신감"
    case conviction = "확신"
    case mindfulness = "무념무상"
    case impulse = "충동"
    case anxious = "불안"
}

// MARK: - TradeDataBuilder
public class TradeDataBuilder: Equatable {
    
    public static func == (lhs: TradeDataBuilder, rhs: TradeDataBuilder) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier: UUID = UUID()
    private var type: TradeType?
    private var quantity: Int?
    private var stockName: String?
    private var date: Date?
    private var profitRate: Double?
    private var reason: String?
    private var emotion: Emotion?
    
    public init() {}
    
    public func setType(_ type: TradeType) -> TradeDataBuilder {
        self.type = type
        return self
    }
    
    public func setQuantity(_ quantity: Int) -> TradeDataBuilder {
        self.quantity = quantity
        return self
    }
    
    public func setStockName(_ stockName: String) -> TradeDataBuilder {
        self.stockName = stockName
        return self
    }
    
    public func setDate(_ date: Date) -> TradeDataBuilder {
        self.date = date
        return self
    }
    
    public func setProfitRate(_ profitRate: Double?) -> TradeDataBuilder {
        self.profitRate = profitRate
        return self
    }
    
    public func setReason(_ reason: String) -> TradeDataBuilder {
        self.reason = reason
        return self
    }
    
    public func setEmotion(_ emotion: Emotion?) -> TradeDataBuilder {
        self.emotion = emotion
        return self
    }
    
    public func build() throws -> TradeData {
        guard let type = type else {
            throw TradeDataError.missingType
        }
        guard let quantity = quantity else {
            throw TradeDataError.missingQuantity
        }
        guard let stockName = stockName else {
            throw TradeDataError.missingStockName
        }
        guard let date = date else {
            throw TradeDataError.missingDate
        }
        guard let reason = reason else {
            throw TradeDataError.missingReason
        }
        
        return TradeData(
            type: type,
            quantity: quantity,
            stockName: stockName,
            date: date,
            profitRate: profitRate,
            reason: reason,
            emotion: emotion
        )
    }
}

// MARK: - TradeDataError
public enum TradeDataError: Error, LocalizedError {
    case missingType
    case missingQuantity
    case missingStockName
    case missingDate
    case missingReason
}
