//
//  RetrospectionResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import RetrospectionDomainInterface

public struct RetrospectionResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: [RetrospectionCompanyResponseDTO]
}

public struct RetrospectionCompanyResponseDTO: Decodable {
    public let symbol: String
    public let retrospections: [RetrospectionItemResponseDTO]
}

public struct RetrospectionItemResponseDTO: Decodable {
    public let id: Int
    public let orderType: String
    public let price: Int
    public let volume: Int
    public let retrospectionCreatedAt: String
    public let orderCreatedAt: String
}

extension RetrospectionCompanyResponseDTO {
    public func toDomain() -> RetrospectionCompany {
        return RetrospectionCompany(
            symbol: self.symbol,
            retrospections: self.retrospections.map { $0.toDomain() }
        )
    }
}

extension RetrospectionItemResponseDTO {
    public func toDomain() -> Retrospection {
        return Retrospection(
            id: self.id,
            orderType: self.orderType,
            price: self.price,
            volume: self.volume,
            retrospectionCreatedAt: self.retrospectionCreatedAt,
            orderCreatedAt: self.orderCreatedAt
        )
    }
}

