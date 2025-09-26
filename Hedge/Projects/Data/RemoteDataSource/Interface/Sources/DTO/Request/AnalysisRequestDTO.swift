//
//  AnalysisRequestDTO.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

// MARK: - AnalysisRequest
public struct AnalysisRequestDTO: Encodable {
    public let market: String
    public let symbol: String
    public let time: String
    
    public init(
        market: String,
        symbol: String,
        time: String
    ) {
        self.market = market
        self.symbol = symbol
        self.time = time
    }
}
