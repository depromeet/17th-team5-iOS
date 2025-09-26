//
//  FetchFeedbackUseCase.swift
//  FetchFeedbackDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol FetchFeedbackUseCase {
    func execute(id: Int) async throws -> FeedbackData
}
