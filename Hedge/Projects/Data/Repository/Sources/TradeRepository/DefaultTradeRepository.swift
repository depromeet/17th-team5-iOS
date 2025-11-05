//
//  DefaultTradeRepository.swift
//  Repository
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Core
import TradeDomainInterface
import RemoteDataSourceInterface
import LocalDataSourceInterface

public struct DefaultTradeRepository: TradeRepository {
    private let remoteDataSource: RetrospectionListDataSource
    private let localDataSource: TradeLocalDataSource
    
    public init(
        remoteDataSource: RetrospectionListDataSource,
        localDataSource: TradeLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    /// Fetch trade records with cache-first strategy:
    /// 1. Return cached data immediately if available
    /// 2. Fetch from API in background
    /// 3. Update cache and return fresh data
    public func fetchTradeRecords() async throws -> [TradeData] {
        // Load from cache first
        if let cachedRecords = localDataSource.loadTradeRecords() {
            // Return cached data immediately, then refresh in background
            Task {
                do {
                    let response = try await remoteDataSource.fetchRetrospections()
                    let dtos = response.toRetrospectionDataDTOs()
                    let records = dtos.map { $0.toTradeData() }
                    localDataSource.saveTradeRecords(records)
                } catch {
                    // Silently fail refresh - cached data is still valid
                    #if DEBUG
                    print("⚠️ DefaultTradeRepository: Failed to refresh trade records: \(error)")
                    #endif
                }
            }
            return cachedRecords
        }
        
        // No cache: fetch from API
        let response = try await remoteDataSource.fetchRetrospections()
        let dtos = response.toRetrospectionDataDTOs()
        let records = dtos.map { $0.toTradeData() }
        
        // Save to cache
        localDataSource.saveTradeRecords(records)
        
        return records
    }
    
    /// Fetch badge counts with cache-first strategy
    public func fetchBadgeCounts() async throws -> BadgeCounts {
        // Load from cache first
        if let cachedCounts = localDataSource.loadBadgeCounts() {
            // Return cached data immediately, then refresh in background
            Task {
                do {
                    let response = try await remoteDataSource.fetchBadgeCounts()
                    let counts = response.data.toDomain()
                    localDataSource.saveBadgeCounts(counts)
                } catch {
                    // Silently fail refresh - cached data is still valid
                    #if DEBUG
                    print("⚠️ DefaultTradeRepository: Failed to refresh badge counts: \(error)")
                    #endif
                }
            }
            return cachedCounts
        }
        
        // No cache: fetch from API
        let response = try await remoteDataSource.fetchBadgeCounts()
        let counts = response.data.toDomain()
        
        // Save to cache
        localDataSource.saveBadgeCounts(counts)
        
        return counts
    }
}

