//
//  Principle.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct Principle: Equatable, Hashable, Codable {
    public let id: Int
    public let groupId: Int
    public let groupName: String
    public let principleType: String
    public let principle: String
    public let description: String
    public let displayOrder: Int
    
    public init(
        id: Int,
        groupId: Int,
        groupName: String,
        principleType: String,
        principle: String,
        description: String,
        displayOrder: Int
    ) {
        self.id = id
        self.groupId = groupId
        self.groupName = groupName
        self.principleType = principleType
        self.principle = principle
        self.description = description
        self.displayOrder = displayOrder
    }
    
    public init(id: Int, principle: String) {
        self.id = id
        self.principle = principle
        self.groupId = 0
        self.groupName = ""
        self.principleType = ""
        self.description = ""
        self.displayOrder = 0
    }
}
