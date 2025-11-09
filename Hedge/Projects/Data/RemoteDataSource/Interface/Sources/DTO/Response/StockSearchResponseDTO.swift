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
    public let data: StockSearchDataWrapperDTO
}

public struct StockSearchDataWrapperDTO: Decodable {
    public let content: [StockSearchDataResponseDTO]
    public let nextCursor: String?
}

public struct StockSearchDataResponseDTO: Decodable {
    public let market: String
    public let code: String
    public let companyName: String
    public let logo: String?
}

extension StockSearchDataWrapperDTO {
    public func toDomain() -> [StockSearch] {
        return content.map { $0.toDomain() }
    }
}

extension StockSearchDataResponseDTO {
    public func toDomain() -> StockSearch {
        return StockSearch(
            market: self.market,
            code: self.code,
            companyName: self.companyName,
            logo: self.logo
        )
    }
}
