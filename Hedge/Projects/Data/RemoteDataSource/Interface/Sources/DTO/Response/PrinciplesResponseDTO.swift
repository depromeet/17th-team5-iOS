//
//  PrinciplesResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface

public struct PrinciplesResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: [PrincipleGroupResponseDTO]
}

public struct PrincipleGroupResponseDTO: Decodable {
    public let id: Int
    public let groupName: String
    public let principleType: String
    public let thumbnail: String
    public let displayOrder: Int?
    public let principles: [PrincipleResponseDTO]
}

public struct PrincipleResponseDTO: Decodable {
    public let id: Int
    public let groupId: Int
    public let groupName: String
    public let principleType: String
    public let principle: String
    public let description: String
    public let displayOrder: Int?
}

extension PrincipleGroupResponseDTO {
    public func toDomain() -> PrincipleGroup {
        
        return PrincipleGroup(
            id: self.id,
            groupName: self.groupName,
            principleType: self.principleType,
            thumbnail: self.thumbnail,
            groupType: PrincipleGroup.GroupType.init(rawValue: self.principleType) ?? .custom,
            displayOrder: self.displayOrder,
            principles: self.principles.map { $0.toDomain() }
        )
    }
}

extension PrincipleResponseDTO {
    public func toDomain() -> Principle {
        return Principle(
            id: self.id,
            groupId: self.groupId,
            groupName: self.groupName,
            principleType: self.principleType,
            principle: self.principle,
            description: self.description,
            displayOrder: self.displayOrder
        )
    }
}
