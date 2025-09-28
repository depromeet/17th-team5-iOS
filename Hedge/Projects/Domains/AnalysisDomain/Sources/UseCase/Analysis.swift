//
//  Analysis.swift
//  AnalysisDomain
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import AnalysisDomainInterface

public struct Analysis: AnalysisUseCase {
    private let repository: AnalysisRepository
    
    public init(repository: AnalysisRepository) {
        self.repository = repository
    }
    
    public func execute(market: String, symbol: String, time: String) async throws -> String {
        try await repository.fetch(market: market, symbol: symbol, time: time)
    }
}
