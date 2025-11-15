//
//  CreateFeedbackUseCase.swift
//  FeedbackDomain
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol CreateFeedbackUseCase {
    func execute(id: Int) async throws -> FeedbackData
}

