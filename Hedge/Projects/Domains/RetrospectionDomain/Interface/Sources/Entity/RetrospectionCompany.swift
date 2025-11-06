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
    public let symbol: String
    public let retrospections: [Retrospection]
    
    public init(
        symbol: String,
        retrospections: [Retrospection]
    ) {
        self.symbol = symbol
        self.retrospections = retrospections
    }
}
