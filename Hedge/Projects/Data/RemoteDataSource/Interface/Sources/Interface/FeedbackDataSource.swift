//
//  FeedbackDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol FeedbackDataSource {
    /// 피드백 조회
    func fetch(id: Int) async throws -> FeedbackResponseDTO
}
