//
//  DefaultPrinciplesRepository.swift
//  Repository
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface
import RemoteDataSourceInterface

public struct DefaultPrinciplesRepository: PrinciplesRepository {
    private let dataSource: PrinciplesDataSource
    
    public init(dataSource: PrinciplesDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> [Principle] {
        return try await dataSource.fetch().data.map { $0.toDomain() }
    }
}
