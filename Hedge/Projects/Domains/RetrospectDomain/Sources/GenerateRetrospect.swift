//
//  GenerateRetrospect.swift
//  ReprospectDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RetrospectDomainInterface

public struct GenerateRetrospect: GenerateRetrospectUseCase {
    private let retrospectRepository: RetrospectRepository
    
    public init(retrospectRepository: RetrospectRepository) {
        self.retrospectRepository = retrospectRepository
    }
    
    public func execute(_ request: GenerateRetrospectRequest) async throws -> Int {
        try await retrospectRepository.generate(request: request)
    }
}
