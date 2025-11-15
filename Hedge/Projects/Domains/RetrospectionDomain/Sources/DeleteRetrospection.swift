//
//  DeleteRetrospection.swift
//  RetrospectionDomain
//
//  Created by Auto on 11/14/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RetrospectionDomainInterface

public struct DeleteRetrospection: DeleteRetrospectionUseCase {
    private let repository: RetrospectionRepository
    
    public init(repository: RetrospectionRepository) {
        self.repository = repository
    }
    
    public func execute(retrospectionId: Int) async throws {
        try await repository.deleteRetrospection(retrospectionId: retrospectionId)
    }
}

