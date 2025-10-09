//
//  FetchPrinciples.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import PrinciplesDomainInterface

public struct FetchPrinciples: FetchPrinciplesUseCase {
    private let repository: PrinciplesRepository
    
    public init(repository: PrinciplesRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Principle] {
        return try await repository.fetch()
    }
}

public struct MockFetchPrinciples: FetchPrinciplesUseCase {
    public init() {}
    
    public func execute() async throws -> [Principle] {
        return [
            Principle(id: 0, principle: "첫번째 레슨"),
            Principle(id: 1, principle: "두번째 레슨"),
            Principle(id: 2, principle: "세번째 레슨"),
            Principle(id: 3, principle: "네번째 레슨"),
            Principle(id: 4, principle: "다섯번째 레슨")
        ]
    }
}
