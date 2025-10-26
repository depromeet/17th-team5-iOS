//
//  AuthRepository.swift
//  AuthDomain
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol AuthRepository {
    func social(
        provider: SocialProvider,
        authCode: String,
        email: String?,
        nickname: String?
    ) async throws
    
    func isAuthorized() -> Bool
}
