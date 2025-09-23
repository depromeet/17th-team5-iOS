//
//  StockSearchResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import StockDomainInterface

public struct StockSearchResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: [StockSearchDataResponseDTO]
}

public struct StockSearchDataResponseDTO: Decodable {
    public let companyName: String
    public let code: String
    public let market: String
}

extension StockSearchDataResponseDTO {
    public func toDomain() -> StockSearch {
        return StockSearch(
            companyName: companyName,
            code: code,
            market: market
        )
    }
}
