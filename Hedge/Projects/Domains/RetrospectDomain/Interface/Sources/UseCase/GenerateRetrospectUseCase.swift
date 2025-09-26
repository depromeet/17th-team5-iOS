//
//  GenerateRetrospectUseCase.swift
//  ReprospectDomain
//
//  Created by Junyoung on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol GenerateRetrospectUseCase {
    func execute(_ request: GenerateRetrospectRequest) async throws -> Int
}
