//
//  StockDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol StockDataSource {
    /// 주식 검색
    func search(_ request: StockSearchRequestDTO) async throws -> StockSearchResponseDTO
}
