//
//  FetchRetrospectionDetailUseCase.swift
//  RetrospectionDomainInterface
//
//  Created by Auto on 11/13/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol FetchRetrospectionDetailUseCase {
    func execute(retrospectionId: Int) async throws -> RetrospectionDetail
}

