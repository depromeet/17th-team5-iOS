//
//  FetchPrinciples.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface

public struct FetchPrinciples: FetchPrinciplesUseCase {
    private let repository: PrinciplesRepository
    
    public init(repository: PrinciplesRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Principle] {
        return try await repository.fetch()
    }
}
