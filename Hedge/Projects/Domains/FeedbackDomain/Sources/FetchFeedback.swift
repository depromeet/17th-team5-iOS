//
//  FetchFeedback.swift
//  FeedbackDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import FeedbackDomainInterface

public struct FetchFeedback: FetchFeedbackUseCase {
    private let feedbackRepository: FeedbackRepository
    
    public init(feedbackRepository: FeedbackRepository) {
        self.feedbackRepository = feedbackRepository
    }
    
    public func execute(id: Int) async throws -> FeedbackDomainInterface.FeedbackData {
        try await feedbackRepository.fetch(id: id)
    }
}
