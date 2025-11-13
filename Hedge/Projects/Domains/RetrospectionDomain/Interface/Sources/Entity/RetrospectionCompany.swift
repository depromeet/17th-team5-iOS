//
//  RetrospectionCompany.swift
//  RetrospectionDomain
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//
import Foundation

public struct RetrospectionCompany: Equatable, Hashable {
    public let id: UUID = UUID()
    public let companyName: String
    public let image: String
    public let symbol: String
    public let market: String
    public let retrospections: [Retrospection]
    public var isLast: Bool = false
    
    public init(
        companyName: String,
        image: String,
        symbol: String,
        market: String,
        retrospections: [Retrospection]
    ) {
        self.companyName = companyName
        self.image = image
        self.symbol = symbol
        self.market = market
        self.retrospections = retrospections
    }
}
