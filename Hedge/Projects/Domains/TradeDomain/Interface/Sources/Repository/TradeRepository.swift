//
//  TradeRepository.swift
//  TradeDomainInterface
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Core

public protocol TradeRepository {
    /// Fetch all trade records for the home screen
    func fetchTradeRecords() async throws -> [TradeData]
    
    /// Fetch badge counts (emerald, gold, silver, bronze)
    func fetchBadgeCounts() async throws -> BadgeCounts
}

public struct BadgeCounts: Equatable, Codable {
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

