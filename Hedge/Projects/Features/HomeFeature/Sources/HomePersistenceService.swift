//
//  HomePersistenceService.swift
//  HomeFeature
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//
//  Persistence service for HomeFeature data
//  Uses UserDefaults for now, but structured to easily swap with other persistence mechanisms
//

import Foundation
import Core
import HomeFeatureInterface

/// Default implementation of HomePersistenceServiceProtocol
/// Uses UserDefaults for persistence
/// All methods and initializer are public to allow usage across modules
public final class HomePersistenceService: HomePersistenceServiceProtocol {
    private let userDefaults: UserDefaults
    private let tradeRecordsKey = "HomeFeature.tradeRecords"
    private let badgeDotsKey = "HomeFeature.badgeDots"
    private let showHelpBubbleKey = "HomeFeature.showHelpBubble"
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func loadTradeRecords() -> [TradeData]? {
        guard let data = userDefaults.data(forKey: tradeRecordsKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([TradeData].self, from: data)
        } catch {
            #if DEBUG
            print("❌ Failed to decode trade records: \(error)")
            #endif
            return nil
        }
    }
    
    public func saveTradeRecords(_ records: [TradeData]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(records)
            userDefaults.set(data, forKey: tradeRecordsKey)
        } catch {
            #if DEBUG
            print("❌ Failed to encode trade records: \(error)")
            #endif
        }
    }
    
    public func loadBadgeDots() -> Set<Int> {
        guard let array = userDefaults.array(forKey: badgeDotsKey) as? [Int] else {
            return []
        }
        return Set(array)
    }
    
    public func saveBadgeDots(_ dots: Set<Int>) {
        let array = Array(dots)
        userDefaults.set(array, forKey: badgeDotsKey)
    }
    
    public func loadShowHelpBubble() -> Bool? {
        // If key doesn't exist, return nil (meaning it hasn't been set yet - should show on first install)
        if userDefaults.object(forKey: showHelpBubbleKey) == nil {
            return nil
        }
        return userDefaults.bool(forKey: showHelpBubbleKey)
    }
    
    public func saveShowHelpBubble(_ show: Bool) {
        userDefaults.set(show, forKey: showHelpBubbleKey)
    }
    
    public func clearAll() {
        userDefaults.removeObject(forKey: tradeRecordsKey)
        userDefaults.removeObject(forKey: badgeDotsKey)
        userDefaults.removeObject(forKey: showHelpBubbleKey)
    }
}

