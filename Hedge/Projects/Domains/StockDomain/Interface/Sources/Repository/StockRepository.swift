//
//  StockRepository.swift
//  StockDomain
//
//  Created by Junyoung on 9/18/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol StockRepository {
    func search(text: String) async throws -> [StockSearch]
}
