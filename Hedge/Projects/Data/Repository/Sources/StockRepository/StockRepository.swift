//
//  StockRepository.swift
//  Repository
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import StockDomainInterface
import RemoteDataSourceInterface

public struct DefaultStockRepository: StockRepository {
    private let dataSource: StockDataSource
    
    public init(dataSource: StockDataSource) {
        self.dataSource = dataSource
    }
    
    public func search(text: String) async throws -> [StockSearch] {
        let request = StockSearchRequestDTO(query: text)
        return try await dataSource.search(request).data.map { $0.toDomain() }
    }
}
