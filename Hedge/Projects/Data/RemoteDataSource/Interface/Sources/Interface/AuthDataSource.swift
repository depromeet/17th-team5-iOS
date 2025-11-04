//
//  AuthDataSource.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol AuthDataSource {
    func social(_ request: SocialLoginRequestDTO) async throws -> SocialLoginResponseDTO
}
