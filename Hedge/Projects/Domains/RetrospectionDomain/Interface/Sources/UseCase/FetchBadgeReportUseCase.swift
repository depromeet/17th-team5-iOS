//
//  FetchBadgeReportUseCase.swift
//  RetrospectionDomainInterface
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

public protocol FetchBadgeReportUseCase {
    func execute() async throws -> RetrospectionBadgeReport
}

