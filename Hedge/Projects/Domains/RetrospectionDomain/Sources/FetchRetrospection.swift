//
//  FetchRetrospection.swift
//  RetrospectionDomain
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RetrospectionDomainInterface

public struct FetchRetrospection: RetrospectionUseCase {
    private let repository: RetrospectionRepository
    
    public init(repository: RetrospectionRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [RetrospectionCompany] {
        return try await repository.fetchCompanies()
    }
}
