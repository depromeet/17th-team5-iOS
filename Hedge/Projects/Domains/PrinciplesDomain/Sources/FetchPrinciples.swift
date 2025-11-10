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
    
    public func execute(_ tradeType: String) async throws -> [PrincipleGroup] {
        var principleGroup = try await repository.fetch()
        
        principleGroup = principleGroup
            .filter { group in
                group.principleType == tradeType
            }
        
        return principleGroup
    }
}
