//
//  CreatePrincipleGroupUseCase.swift
//  PrinciplesDomain
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol CreatePrincipleGroupUseCase {
    func execute(
        groupName: String,
        displayOrder: Int,
        principleType: String,
        thumbnail: String,
        principles: [(principle: String, description: String)]
    ) async throws -> PrincipleGroup
}

