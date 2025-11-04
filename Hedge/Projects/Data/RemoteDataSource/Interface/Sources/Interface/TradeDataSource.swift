//
//  RetrospectionListDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Dongjoo on 11/1/25.
//  Copyright © 2025 depromeet. All rights reserved.
//

import Foundation

/// Data source for fetching retrospections (trade records) from the API
/// NOTE: RetrospectDataSource handles creating retrospections (POST)
/// This protocol handles fetching retrospections (GET list, badges)
public protocol RetrospectionListDataSource {
    /// Fetch all retrospections (trade records) for the home screen
    /// Real API: GET /api/v1/retrospections
    func fetchRetrospections() async throws -> RetrospectionListResponseDTO
    
    /// Fetch badge counts
    /// NOTE: This API endpoint doesn't exist in Swagger.
    /// Badges are calculated from retrospection data instead (see HomeFeature).
    /// This method returns zeros for backwards compatibility.
    func fetchBadgeCounts() async throws -> BadgeCountsResponseDTO
}

