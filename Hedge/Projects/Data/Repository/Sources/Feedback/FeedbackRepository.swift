//
//  FeedbackRepository.swift
//  Repository
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import FeedbackDomainInterface
import RemoteDataSourceInterface

public struct DefaultFeedbackRepository: FeedbackRepository {
    private let dataSource: FeedbackDataSource
    
    public init(dataSource: FeedbackDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(id: Int) async throws -> FeedbackData {
        try await dataSource.fetch(id: id).data.toDomain()
    }
}
