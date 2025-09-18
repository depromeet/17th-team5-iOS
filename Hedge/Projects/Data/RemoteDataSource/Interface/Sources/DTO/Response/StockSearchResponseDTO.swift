//
//  StockSearchResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct StockSearchResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: [StockSearchDataResponseDTO]
}

public struct StockSearchDataResponseDTO: Decodable {
    public let symbol: String
    public let title: String
    public let market: String
}
