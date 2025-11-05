//
//  TradeLocalDataSource.swift
//  LocalDataSourceInterface
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Core
import TradeDomainInterface

public protocol TradeLocalDataSource {
    /// Load trade records from local storage
    func loadTradeRecords() -> [TradeData]?
    
    /// Save trade records to local storage
    func saveTradeRecords(_ records: [TradeData])
    
    /// Load badge counts from local storage
    func loadBadgeCounts() -> BadgeCounts?
    
    /// Save badge counts to local storage
    func saveBadgeCounts(_ counts: BadgeCounts)
    
    /// Clear all cached data
    func clearAll()
}

