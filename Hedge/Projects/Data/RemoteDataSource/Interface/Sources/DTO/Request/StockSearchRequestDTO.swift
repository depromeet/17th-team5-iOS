//
//  StockSearchRequestDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct StockSearchRequestDTO: Encodable {
    let companyName: String
    let nextCursor: String?
    let size: Int
    
    public init(companyName: String, nextCursor: String? = nil, size: Int = 10) {
        self.companyName = companyName
        self.nextCursor = nextCursor
        self.size = size
    }
}
