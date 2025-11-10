//
//  BadgeReportResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

import RetrospectionDomainInterface

public struct BadgeReportResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: BadgeReportDataDTO
}

public struct BadgeReportDataDTO: Decodable {
    public let hedge: Int
    public let bronze: Int
    public let silver: Int
    public let gold: Int
    public let percentage: Double
}

public extension BadgeReportDataDTO {
    func toDomain() -> RetrospectionBadgeReport {
        RetrospectionBadgeReport(
            hedge: hedge,
            bronze: bronze,
            silver: silver,
            gold: gold,
            percentage: percentage
        )
    }
}

