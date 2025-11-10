//
//  RetrospectionCreateResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

import RetrospectionDomainInterface

public struct RetrospectionCreateResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: RetrospectionCreateDataDTO
}

public struct RetrospectionCreateDataDTO: Decodable {
    public let id: Int
    public let userId: Int
    public let symbol: String
    public let market: String
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double?
    public let createdAt: String
    public let updatedAt: String
}

public extension RetrospectionCreateDataDTO {
    func toDomain() -> RetrospectionCreateResult {
        RetrospectionCreateResult(
            id: id,
            userId: userId,
            symbol: symbol,
            market: market,
            orderType: orderType,
            price: price,
            currency: currency,
            volume: volume,
            orderDate: orderDate,
            returnRate: returnRate,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

