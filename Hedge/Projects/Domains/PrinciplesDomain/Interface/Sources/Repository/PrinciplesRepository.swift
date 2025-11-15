//
//  PrinciplesRepository.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol PrinciplesRepository {
    func fetch() async throws -> [PrincipleGroup]
    func fetchSystemPrincipleGroups() async throws -> [PrincipleGroup]
    func fetchRecommendedPrincipleGroups() async throws -> [PrincipleGroup]
    func fetchDefaultPrincipleGroups() async throws -> [PrincipleGroup]
    func createPrincipleGroup(
        groupName: String,
        displayOrder: Int,
        principleType: String,
        thumbnail: String,
        principles: [(principle: String, description: String)]
    ) async throws -> PrincipleGroup
}
