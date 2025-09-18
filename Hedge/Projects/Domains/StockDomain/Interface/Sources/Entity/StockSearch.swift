//
//  StockSearch.swift
//  SampleDomain
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct StockSearch {
    public let symbol: String
    public let title: String
    public let market: String
    
    public init(
        symbol: String,
        title: String,
        market: String
    ) {
        self.symbol = symbol
        self.title = title
        self.market = market
    }
}
