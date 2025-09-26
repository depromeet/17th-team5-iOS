//
//  GenerateRetrospectResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

// MARK: - GenerateRetrospectResponseDTO
public struct GenerateRetrospectResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: GenerateRetrospectDataDTO
}

// MARK: - GenerateRetrospectDataDTO
public struct GenerateRetrospectDataDTO: Decodable {
    public let id: Int
    public let userId: Int
    public let symbol: String
    public let market: String
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double
    public let content: String
    public let emotion: String
    public let createdAt: String
    public let updatedAt: String
}
