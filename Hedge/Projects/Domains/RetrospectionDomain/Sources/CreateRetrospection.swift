//
//  CreateRetrospection.swift
//  RetrospectionDomain
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

import RetrospectionDomainInterface

public struct CreateRetrospection: CreateRetrospectionUseCase {
    private let repository: RetrospectionRepository
    
    public init(repository: RetrospectionRepository) {
        self.repository = repository
    }
    
    public func execute(_ request: RetrospectionCreateRequest) async throws -> RetrospectionCreateResult {
        try await repository.createRetrospection(request)
    }
}

