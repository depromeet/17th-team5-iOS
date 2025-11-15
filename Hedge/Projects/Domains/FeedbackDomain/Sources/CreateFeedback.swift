//
//  CreateFeedback.swift
//  FeedbackDomain
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import FeedbackDomainInterface

public struct CreateFeedback: CreateFeedbackUseCase {
    private let feedbackRepository: FeedbackRepository
    
    public init(feedbackRepository: FeedbackRepository) {
        self.feedbackRepository = feedbackRepository
    }
    
    public func execute(id: Int) async throws -> FeedbackData {
        try await feedbackRepository.create(id: id)
    }
}

