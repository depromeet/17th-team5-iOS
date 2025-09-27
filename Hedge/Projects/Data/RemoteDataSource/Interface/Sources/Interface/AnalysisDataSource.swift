//
//  AnalysisDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 9/27/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol AnalysisDataSource {
    /// 회고 생성
    func fetch(_ request: AnalysisRequestDTO) async throws -> AnalysisResponseDTO
}
