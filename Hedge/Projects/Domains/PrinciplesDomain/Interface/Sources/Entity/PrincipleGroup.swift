//
//  PrincipleGroup.swift
//  PrinciplesDomainInterface
//
//  Created by 이중엽 on 11/1/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct PrincipleGroup: Equatable, Hashable {
    public let id: Int
    public let groupName: String
    public let principleType: String
    public let displayOrder: Int
    public let principles: [Principle]
    
    public init(
        id: Int,
        groupName: String,
        principleType: String,
        displayOrder: Int,
        principles: [Principle]
    ) {
        self.id = id
        self.groupName = groupName
        self.principleType = principleType
        self.displayOrder = displayOrder
        self.principles = principles
    }
}
