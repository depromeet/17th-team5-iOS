//
//  FetchTradeRecords.swift
//  TradeDomain
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Core
import TradeDomainInterface

public struct FetchTradeRecords: FetchTradeRecordsUseCase {
    private let tradeRepository: TradeRepository
    
    public init(tradeRepository: TradeRepository) {
        self.tradeRepository = tradeRepository
    }
    
    public func execute() async throws -> [TradeData] {
        try await tradeRepository.fetchTradeRecords()
    }
}

public struct FetchBadgeCounts: FetchBadgeCountsUseCase {
    private let tradeRepository: TradeRepository
    
    public init(tradeRepository: TradeRepository) {
        self.tradeRepository = tradeRepository
    }
    
    public func execute() async throws -> BadgeCounts {
        try await tradeRepository.fetchBadgeCounts()
    }
}

