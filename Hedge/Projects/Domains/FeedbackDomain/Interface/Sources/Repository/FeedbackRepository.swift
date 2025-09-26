//
//  FeedbackRepository.swift
//  FeedbackDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol FeedbackRepository {
    func fetch(id: Int) async throws -> FeedbackData
}
