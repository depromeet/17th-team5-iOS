//
//  DefaultRetrospectionListDataSource.swift
//  RemoteDataSource
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

import Alamofire

import Networker
@preconcurrency import RemoteDataSourceInterface

public struct DefaultRetrospectionListDataSource: RetrospectionListDataSource {
    private let provider: Provider
    
    public init() {
        self.provider = Provider.plain
    }
    
    // MARK: - Real Implementation: Fetch Retrospections
    /// Real API: GET /api/v1/retrospections
    public func fetchRetrospections() async throws -> RetrospectionListResponseDTO {
        return try await provider.request(RetrospectionListTarget.fetchRetrospections)
    }
    
    // MARK: - Fetch Badge Counts (Not in Swagger - Returns zeros)
    /// NOTE: Badge counts API endpoint doesn't exist in Swagger.
    /// Badges are calculated from retrospection data instead (see HomeFeature.badgeCountsTuple).
    /// This method returns zeros for backwards compatibility.
    public func fetchBadgeCounts() async throws -> BadgeCountsResponseDTO {
        // API endpoint doesn't exist - return zeros
        // Badges are calculated client-side from retrospection records
        return BadgeCountsResponseDTO(
            code: "SUCCESS",
            message: "Badges calculated from retrospection data",
            data: BadgeCountsDataDTO(
                emerald: 0,
                gold: 0,
                silver: 0,
                bronze: 0
            )
        )
    }
}

// MARK: - RetrospectionListTarget (for real API endpoints)
enum RetrospectionListTarget {
    case fetchRetrospections
    // Note: fetchBadgeCounts removed - API doesn't exist, badges calculated from retrospection data
}

extension RetrospectionListTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL + "/api/v1"
    }
    
    var header: Alamofire.HTTPHeaders {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchRetrospections:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchRetrospections:
            return "/retrospections"
        }
    }
    
    var parameters: Networker.RequestParams? {
        return nil
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        return makeEncoder(contentType: .json)
    }
}

