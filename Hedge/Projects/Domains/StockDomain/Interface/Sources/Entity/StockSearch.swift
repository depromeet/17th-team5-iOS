//
//  StockSearch.swift
//  SampleDomain
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct StockSearch: Equatable, Hashable {
    public let companyName: String
    public let code: String
    public let market: String
    
    public init(
        companyName: String,
        code: String,
        market: String
    ) {
        self.companyName = companyName
        self.code = code
        self.market = market
    }
}
