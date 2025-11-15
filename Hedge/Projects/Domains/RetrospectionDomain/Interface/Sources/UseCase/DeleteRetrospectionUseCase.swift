//
//  DeleteRetrospectionUseCase.swift
//  RetrospectionDomainInterface
//
//  Created by Auto on 11/14/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol DeleteRetrospectionUseCase {
    func execute(retrospectionId: Int) async throws
}

