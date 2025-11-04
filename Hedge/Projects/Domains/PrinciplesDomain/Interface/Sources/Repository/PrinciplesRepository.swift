//
//  PrinciplesRepository.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol PrinciplesRepository {
    func fetch() async throws -> [PrincipleGroup]
}
