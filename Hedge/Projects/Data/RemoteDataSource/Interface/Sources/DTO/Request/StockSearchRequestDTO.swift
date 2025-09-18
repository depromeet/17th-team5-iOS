//
//  StockSearchRequestDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct StockSearchRequestDTO: Encodable {
    let query: String
    
    public init(query: String) {
        self.query = query
    }
}
