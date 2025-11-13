//
//  RetrospectionDetailResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Auto on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct RetrospectionDetailResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: RetrospectionDetailDataDTO
}

public struct RetrospectionDetailDataDTO: Decodable {
    public let id: Int
    public let userId: Int
    public let symbol: String
    public let market: String
    public let companyName: String
    public let companyLogo: String?
    public let orderType: String
    public let price: Int
    public let currency: String
    public let volume: Int
    public let orderDate: String
    public let returnRate: Double?
    public let badge: String
    public let principleCheckGroup: PrincipleCheckGroupDTO
    public let memos: [MemoDTO]
    public let createdAt: String
    public let updatedAt: String
}

public struct PrincipleCheckGroupDTO: Decodable {
    public let groupId: Int
    public let groupName: String
    public let thumbnail: String?
    public let principleType: String
    public let principleChecks: [PrincipleCheckDTO]
}

public struct PrincipleCheckDTO: Decodable {
    public let principleId: Int
    public let principle: String
    public let status: String
    public let reason: String
    public let imageUrls: [String]
    public let links: [String]
}

public struct MemoDTO: Decodable {
    public let memoId: Int
    public let content: String
    public let createdAt: String
}

// MARK: - Domain Mapping Extensions
import RetrospectionDomainInterface

public extension RetrospectionDetailDataDTO {
    func toDomain() -> RetrospectionDetail {
        RetrospectionDetail(
            id: id,
            userId: userId,
            symbol: symbol,
            market: market,
            companyName: companyName,
            companyLogo: companyLogo,
            orderType: orderType,
            price: price,
            currency: currency,
            volume: volume,
            orderDate: orderDate,
            returnRate: returnRate,
            badge: badge,
            principleCheckGroup: principleCheckGroup.toDomain(),
            memos: memos.map { $0.toDomain() },
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public extension PrincipleCheckGroupDTO {
    func toDomain() -> PrincipleCheckGroup {
        PrincipleCheckGroup(
            groupId: groupId,
            groupName: groupName,
            thumbnail: thumbnail,
            principleType: principleType,
            principleChecks: principleChecks.map { $0.toDomain() }
        )
    }
}

public extension PrincipleCheckDTO {
    func toDomain() -> PrincipleCheck {
        PrincipleCheck(
            principleId: principleId,
            principle: principle,
            status: RetrospectionPrincipleStatus(rawValue: status) ?? .neutral,
            reason: reason,
            imageUrls: imageUrls,
            links: links
        )
    }
}

public extension MemoDTO {
    func toDomain() -> Memo {
        Memo(
            memoId: memoId,
            content: content,
            createdAt: createdAt
        )
    }
}

