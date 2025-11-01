//
//  Principle.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct Principle: Equatable, Hashable {
    public let id: Int
    public let groupId: Int
    public let groupName: String
    public let principleType: String
    public let principle: String
    public let displayOrder: Int
    
    public init(
        id: Int,
        groupId: Int,
        groupName: String,
        principleType: String,
        principle: String,
        displayOrder: Int
    ) {
        self.id = id
        self.groupId = groupId
        self.groupName = groupName
        self.principleType = principleType
        self.principle = principle
        self.displayOrder = displayOrder
    }
}
