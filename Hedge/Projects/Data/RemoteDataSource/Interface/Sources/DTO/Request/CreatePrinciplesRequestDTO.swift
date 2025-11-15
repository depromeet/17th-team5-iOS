//
//  CreatePrincipleGroupRequestDTO.swift
//  RemoteDataSource
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct CreatePrincipleGroupRequestDTO: Encodable {
    public let groupName: String
    public let displayOrder: Int
    public let principleType: String
    public let thumbnail: String
    public let principles: [PrincipleItemDTO]
    
    public init(
        groupName: String,
        displayOrder: Int,
        principleType: String,
        thumbnail: String,
        principles: [PrincipleItemDTO]
    ) {
        self.groupName = groupName
        self.displayOrder = displayOrder
        self.principleType = principleType
        self.thumbnail = thumbnail
        self.principles = principles
    }
}

public struct PrincipleItemDTO: Encodable {
    public let principle: String
    public let description: String
    
    public init(principle: String, description: String) {
        self.principle = principle
        self.description = description
    }
}

