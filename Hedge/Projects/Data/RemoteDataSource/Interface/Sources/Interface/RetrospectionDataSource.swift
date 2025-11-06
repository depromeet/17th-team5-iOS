//
//  RetrospectionDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol RetrospectionDataSource {
    func fetch() async throws -> RetrospectionResponseDTO
}

