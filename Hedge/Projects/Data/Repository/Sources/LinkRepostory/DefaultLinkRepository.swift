//
//  DefaultLinkRepository.swift
//  Repository
//
//  Created by 이중엽 on 10/21/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RemoteDataSourceInterface
import LinkDomainInterface

public struct DefaultLinkRepository: LinkRepository {
    
    private let dataSource: LinkDataSource
    
    public init(dataSource: LinkDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(urlString: String) async throws -> LinkMetadata {
        return try await dataSource.fetch(urlString: urlString).toDomain()
    }
}
