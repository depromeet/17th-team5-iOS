//
//  DefaultFeedbackRepository.swift
//  Repository
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

import FeedbackDomainInterface
import RemoteDataSourceInterface

public struct DefaultFeedbackRepository: FeedbackRepository {
    private let dataSource: FeedbackDataSource
    
    public init(dataSource: FeedbackDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(id: Int) async throws -> FeedbackData {
        let response = try await dataSource.fetchFeedback(retrospectionId: id)
        return response.data.toDomain()
    }
}

