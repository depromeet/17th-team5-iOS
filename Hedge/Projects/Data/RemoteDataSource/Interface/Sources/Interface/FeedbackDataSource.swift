//
//  FeedbackDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol FeedbackDataSource {
    func fetch(id: Int) async throws -> FeedbackResponseDTO
}
