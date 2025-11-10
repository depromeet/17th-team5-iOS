//
//  CreateRetrospectionUseCase.swift
//  RetrospectionDomainInterface
//
//  Created by ChatGPT on 11/9/25.
//

import Foundation

public protocol CreateRetrospectionUseCase {
    func execute(_ request: RetrospectionCreateRequest) async throws -> RetrospectionCreateResult
}

