//
//  StockSearch.swift
//  SampleDomain
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct StockSearch: Equatable, Hashable {
    public let market: String
    public let code: String
    public let companyName: String
    public let logo: String?
    
    
    public init(
        market: String,
        code: String,
        companyName: String,
        logo: String?
    ) {
        self.market = market
        self.code = code
        self.companyName = companyName
        self.logo = logo
    }
}
