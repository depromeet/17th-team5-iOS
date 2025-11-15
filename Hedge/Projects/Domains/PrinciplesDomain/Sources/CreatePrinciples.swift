//
//  CreatePrincipleGroup.swift
//  PrinciplesDomain
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface

public struct CreatePrincipleGroup: CreatePrincipleGroupUseCase {
    private let principlesRepository: PrinciplesRepository
    
    public init(principlesRepository: PrinciplesRepository) {
        self.principlesRepository = principlesRepository
    }
    
    public func execute(
        groupName: String,
        displayOrder: Int,
        principleType: String,
        thumbnail: String,
        principles: [(principle: String, description: String)]
    ) async throws -> PrincipleGroup {
        try await principlesRepository.createPrincipleGroup(
            groupName: groupName,
            displayOrder: displayOrder,
            principleType: principleType,
            thumbnail: thumbnail,
            principles: principles
        )
    }
}

