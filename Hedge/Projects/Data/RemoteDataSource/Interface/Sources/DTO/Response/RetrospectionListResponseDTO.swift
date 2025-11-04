//
//  RetrospectionListResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Core
import PrinciplesDomainInterface

// MARK: - RetrospectionListResponseDTO
/// Response DTO for GET /api/v1/retrospections (list of retrospections)
/// API returns retrospections grouped by symbol
public struct RetrospectionListResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: [RetrospectionGroupDTO]
    
    public init(code: String, message: String, data: [RetrospectionGroupDTO]) {
        self.code = code
        self.message = message
        self.data = data
    }
    
    /// Flatten grouped retrospections into a single array
    /// Each retrospection in the list has minimal fields, so we use defaults for missing ones
    public func toRetrospectionDataDTOs() -> [RetrospectionDataDTO] {
        return data.flatMap { group in
            group.retrospections.map { retrospection in
                // Infer market from symbol
                let market = MarketInferrer.market(for: group.symbol)
                // Infer currency from market
                let currency = market == "KRX" ? "KRW" : "USD"
                
                return RetrospectionDataDTO(
                    id: retrospection.id,
                    userId: 1, // Default - API doesn't return this in list
                    symbol: group.symbol,
                    market: market,
                    orderType: retrospection.orderType,
                    price: retrospection.price,
                    currency: currency,
                    volume: retrospection.volume,
                    orderDate: retrospection.orderDate,
                    returnRate: nil, // Not in list response - fetch detail if needed
                    content: nil, // Not in list response - fetch detail if needed
                    emotion: nil, // Not in list response - fetch detail if needed
                    principleChecks: nil, // Not in list response - fetch detail if needed
                    memos: nil, // Not in list response
                    createdAt: retrospection.retrospectionCreatedAt,
                    updatedAt: retrospection.retrospectionCreatedAt
                )
            }
        }
    }
}

// MARK: - MarketInferrer
/// Helper to infer market from stock symbol
private enum MarketInferrer {
    /// Korean stock symbols are typically 6-digit numbers (e.g., "005930")
    /// US stocks are typically 1-5 letter codes (e.g., "TSLA", "AAPL")
    static func market(for symbol: String) -> String {
        // Check if symbol is numeric (Korean market)
        if let _ = Int(symbol), symbol.count == 6 {
            return "KRX"
        }
        // Default to NASDAQ for US stocks
        return "NASDAQ"
    }
}

// MARK: - RetrospectionGroupDTO
/// Represents a group of retrospections for a single symbol
public struct RetrospectionGroupDTO: Decodable {
    public let symbol: String
    public let retrospections: [RetrospectionListItemDTO]
}

// MARK: - RetrospectionListItemDTO
/// Minimal retrospection data from the list endpoint
public struct RetrospectionListItemDTO: Decodable {
    public let id: Int
    public let orderType: String
    public let price: Double
    public let volume: Int
    public let retrospectionCreatedAt: String
    public let orderDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderType
        case price
        case volume
        case retrospectionCreatedAt
        case orderDate = "orderCreatedAt"
    }
}

// MARK: - RetrospectionDataDTO
/// Data DTO representing a single retrospection (trade record)
/// Maps to TradeData domain model
public struct RetrospectionDataDTO: Decodable {
    public let id: Int
    public let userId: Int
    public let symbol: String
    public let market: String
    public let orderType: String // "BUY" or "SELL"
    public let price: Double
    public let currency: String
    public let volume: Int
    public let orderDate: String // "2025-09-13"
    public let returnRate: Double?
    public let content: String?
    public let emotion: String? // "CONFIDENCE", etc.
    public let principleChecks: [PrincipleCheckDTO]?
    public let memos: [MemoDTO]?
    public let createdAt: String
    public let updatedAt: String
    
    public init(
        id: Int,
        userId: Int,
        symbol: String,
        market: String,
        orderType: String,
        price: Double,
        currency: String,
        volume: Int,
        orderDate: String,
        returnRate: Double?,
        content: String?,
        emotion: String?,
        principleChecks: [PrincipleCheckDTO]?,
        memos: [MemoDTO]?,
        createdAt: String,
        updatedAt: String
    ) {
        self.id = id
        self.userId = userId
        self.symbol = symbol
        self.market = market
        self.orderType = orderType
        self.price = price
        self.currency = currency
        self.volume = volume
        self.orderDate = orderDate
        self.returnRate = returnRate
        self.content = content
        self.emotion = emotion
        self.principleChecks = principleChecks
        self.memos = memos
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - PrincipleCheckDTO
public struct PrincipleCheckDTO: Decodable {
    public let principleId: Int
    public let principle: String
    public let status: String // "KEPT", "BROKEN"
    public let reason: String?
    public let imageUrls: [String]
    public let links: [String]
    
    public init(
        principleId: Int,
        principle: String,
        status: String,
        reason: String?,
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

// MARK: - MemoDTO
public struct MemoDTO: Decodable, Encodable {
    public let memoId: Int
    public let content: String
    
    public init(memoId: Int, content: String) {
        self.memoId = memoId
        self.content = content
    }
}

// MARK: - Stock Symbol to Title Mapping
/// Maps stock symbols to their display titles
/// Used when API doesn't provide stockTitle in response
private enum StockSymbolMapper {
    private static let symbolMap: [String: String] = [
        // Korean stocks
        "005930": "삼성전자",
        "000660": "SK하이닉스",
        "035420": "NAVER",
        "035720": "카카오",
        
        // US stocks
        "TSLA": "테슬라",
        "AAPL": "애플",
        "MSFT": "마이크로소프트",
        "GOOGL": "구글",
        "AMZN": "아마존",
    ]
    
    static func title(for symbol: String) -> String? {
        return symbolMap[symbol.uppercased()]
    }
}

// MARK: - Extension: DTO to Domain Conversion
extension RetrospectionDataDTO {
    /// Convert DTO to TradeData domain entity
    /// TradeData is the domain model used throughout the app for trade records with retrospection
    public func toTradeData() -> TradeData {
        // Parse orderDate from "2025-09-13" to "2025.09.13"
        let formattedDate = orderDate.replacingOccurrences(of: "-", with: ".")
        
        // Convert orderType "BUY"/"SELL" to TradeType
        let tradeType: TradeType = orderType == "BUY" ? .buy : .sell
        
        // Convert emotion string to TradeEmotion
        // API values: CONFIDENCE, CONVICTION, NEUTRAL, IMPULSE, ANXIOUS
        let tradeEmotion: TradeEmotion? = {
            guard let emotion = emotion else { return nil }
            switch emotion.uppercased() {
            case "CONFIDENCE": return .confidence
            case "CONVICTION": return .conviction
            case "NEUTRAL": return .neutral
            case "IMPULSE": return .impulse
            case "ANXIOUS": return .anxious
            default: return nil
            }
        }()
        
        // Convert principleChecks to Principles
        // Principle from PrinciplesDomainInterface only has id and principle (String)
        let principles: [Principle] = principleChecks?.map { check in
            Principle(
                id: check.principleId,
                principle: check.principle
            )
        } ?? []
        
        // Format price and volume as strings with commas
        let formattedPrice = String(format: "%.0f", price).formattedWithCommas()
        let formattedVolume = String(volume).formattedWithCommas()
        
        // Convert returnRate to yield string (percentage)
        let yieldString: String? = returnRate.map { rate in
            String(format: "%.1f%%", rate)
        }
        
        // Use content as retrospection, or empty string
        let retrospection = content ?? ""
        
        // Get stockTitle from symbol using lookup
        // Note: When real API includes stockTitle, this mapping can be removed
        let stockTitle = StockSymbolMapper.title(for: symbol) ?? symbol
        
        return TradeData(
            id: id,
            tradeType: tradeType,
            stockSymbol: symbol,
            stockTitle: stockTitle,
            stockMarket: market,
            tradingPrice: formattedPrice,
            tradingQuantity: formattedVolume,
            tradingDate: formattedDate,
            yield: yieldString,
            emotion: tradeEmotion,
            tradePrinciple: principles,
            retrospection: retrospection
        )
    }
}

// Helper extension for number formatting
private extension String {
    func formattedWithCommas() -> String {
        guard let number = Int(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? self
    }
}

