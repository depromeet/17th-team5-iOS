//
//  AnalysisRepository.swift
//  AnalysisDomain
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol AnalysisRepository {
    func fetch(market: String, symbol: String, time: String) async throws -> String
}
