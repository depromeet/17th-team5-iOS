//
//  DefaultAnalysisRepository.swift
//  Repository
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RemoteDataSourceInterface
import AnalysisDomainInterface

public struct DefaultAnalysisRepository: AnalysisRepository {
    private let dataSource: AnalysisDataSource
    
    public init(dataSource: AnalysisDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(market: String, symbol: String, time: String) async throws -> String {
        let request = AnalysisRequestDTO(market: market, symbol: symbol, time: time)
        return try await dataSource.fetch(request).data.text
    }
}
