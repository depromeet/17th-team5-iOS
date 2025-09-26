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
    public let data: [PrinciplesDataResponseDTO]
}

public struct PrinciplesDataResponseDTO: Decodable {
    public let id: Int
    public let principle: String
}

extension PrinciplesDataResponseDTO {
    public func toDomain() -> Principle {
        return Principle(
            id: self.id,
            principle: self.principle
        )
    }
}
