//
//  RetrospectionRepository.swift
//  RetrospectionDomain
//
//  Created by 이중엽 on 11/6/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

public protocol RetrospectionRepository {
    func fetch() async throws -> [Retrospection]
}
