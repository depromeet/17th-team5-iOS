//
//  RetrospectDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol RetrospectDataSource {
    /// 회고 생성
    func generate(_ request: GenerateRetrospectRequestDTO) async throws -> GenerateRetrospectResponseDTO
}
