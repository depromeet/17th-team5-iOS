//
//  BadgeCountsResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import TradeDomainInterface

// MARK: - BadgeCountsResponseDTO
public struct BadgeCountsResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: BadgeCountsDataDTO
    
    public init(code: String, message: String, data: BadgeCountsDataDTO) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - BadgeCountsDataDTO
public struct BadgeCountsDataDTO: Decodable {
    public let emerald: Int
    public let gold: Int
    public let silver: Int
    public let bronze: Int
    
    public init(emerald: Int, gold: Int, silver: Int, bronze: Int) {
        self.emerald = emerald
        self.gold = gold
        self.silver = silver
        self.bronze = bronze
    }
}

// MARK: - Extension: DTO to Domain Conversion
extension BadgeCountsDataDTO {
    public func toDomain() -> BadgeCounts {
        BadgeCounts(
            emerald: emerald,
            gold: gold,
            silver: silver,
            bronze: bronze
        )
    }
}

