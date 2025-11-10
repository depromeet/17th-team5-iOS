//
//  FeedbackDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

public protocol FeedbackDataSource {
    func fetchFeedback(retrospectionId: Int) async throws -> FeedbackResponseDTO
}

