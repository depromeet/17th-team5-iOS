//
//  FetchStockSearchUseCase.swift
//  SampleDomain
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol FetchStockSearchUseCase {
    func execute(text: String) async throws -> [StockSearch]
}
