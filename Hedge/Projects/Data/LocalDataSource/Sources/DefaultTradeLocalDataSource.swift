//
//  DefaultTradeLocalDataSource.swift
//  LocalDataSource
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Core
import LocalDataSourceInterface
import TradeDomainInterface

public final class DefaultTradeLocalDataSource: TradeLocalDataSource {
    private let userDefaults: UserDefaults
    
    private enum Keys {
        static let tradeRecords = "tradeRecords"
        static let badgeCounts = "badgeCounts"
    }
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func loadTradeRecords() -> [TradeData]? {
        guard let data = userDefaults.data(forKey: Keys.tradeRecords) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let records = try decoder.decode([TradeData].self, from: data)
            return records
        } catch {
            #if DEBUG
            print("⚠️ DefaultTradeLocalDataSource: Failed to decode trade records: \(error)")
            #endif
            return nil
        }
    }
    
    public func saveTradeRecords(_ records: [TradeData]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(records)
            userDefaults.set(data, forKey: Keys.tradeRecords)
        } catch {
            #if DEBUG
            print("⚠️ DefaultTradeLocalDataSource: Failed to encode trade records: \(error)")
            #endif
        }
    }
    
    public func loadBadgeCounts() -> BadgeCounts? {
        guard let data = userDefaults.data(forKey: Keys.badgeCounts) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let counts = try decoder.decode(BadgeCounts.self, from: data)
            return counts
        } catch {
            #if DEBUG
            print("⚠️ DefaultTradeLocalDataSource: Failed to decode badge counts: \(error)")
            #endif
            return nil
        }
    }
    
    public func saveBadgeCounts(_ counts: BadgeCounts) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(counts)
            userDefaults.set(data, forKey: Keys.badgeCounts)
        } catch {
            #if DEBUG
            print("⚠️ DefaultTradeLocalDataSource: Failed to encode badge counts: \(error)")
            #endif
        }
    }
    
    public func clearAll() {
        userDefaults.removeObject(forKey: Keys.tradeRecords)
        userDefaults.removeObject(forKey: Keys.badgeCounts)
    }
}

