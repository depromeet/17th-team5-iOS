//
//  RetrospectionDeleteResponseDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Auto on 11/14/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct RetrospectionDeleteResponseDTO: Decodable {
    public let code: String
    public let message: String
    public let data: String
}

