//
//  CreatePrincipleGroupResponseDTO.swift
//  RemoteDataSource
//
//  Created by Auto on 1/15/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct CreatePrincipleGroupResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: PrincipleGroupResponseDTO
}

