//
//  FetchBadgeReport.swift
//  RetrospectionDomain
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

import RetrospectionDomainInterface

public struct FetchBadgeReport: FetchBadgeReportUseCase {
    private let repository: RetrospectionRepository
    
    public init(repository: RetrospectionRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> RetrospectionBadgeReport {
        try await repository.fetchBadgeReport()
    }
}

