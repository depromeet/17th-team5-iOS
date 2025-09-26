//
//  RetrospectRepository.swift
//  ReprospectDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol RetrospectRepository {
    func generate(request: GenerateRetrospectRequest) async throws -> Int
}
