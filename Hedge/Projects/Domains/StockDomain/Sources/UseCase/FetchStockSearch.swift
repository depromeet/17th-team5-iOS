//
//  FetchStockSearch.swift
//  StockDomain
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import StockDomainInterface

public struct FetchStockSearch: FetchStockSearchUseCase {
    private let repository: StockRepository
    
    public init(repository: StockRepository) {
        self.repository = repository
    }
    
    public func execute(text: String) async throws -> [StockSearch] {
        try await repository.search(text: text)
    }
}
