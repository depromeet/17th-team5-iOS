//
//  FetchTradeRecordsUseCase.swift
//  TradeDomainInterface
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Core

public protocol FetchTradeRecordsUseCase {
    func execute() async throws -> [TradeData]
}

public protocol FetchBadgeCountsUseCase {
    func execute() async throws -> BadgeCounts
}

