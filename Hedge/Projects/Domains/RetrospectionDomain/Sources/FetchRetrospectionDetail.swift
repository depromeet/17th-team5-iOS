//
//  FetchRetrospectionDetail.swift
//  RetrospectionDomain
//
//  Created by Auto on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RetrospectionDomainInterface

public struct FetchRetrospectionDetail: FetchRetrospectionDetailUseCase {
    private let repository: RetrospectionRepository
    
    public init(repository: RetrospectionRepository) {
        self.repository = repository
    }
    
    public func execute(retrospectionId: Int) async throws -> RetrospectionDetail {
        try await repository.fetchDetail(retrospectionId: retrospectionId)
    }
}

