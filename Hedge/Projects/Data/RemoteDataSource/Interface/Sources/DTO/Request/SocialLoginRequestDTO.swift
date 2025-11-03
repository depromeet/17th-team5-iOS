//
//  SocialLoginRequestDTO.swift
//  RemoteDataSourceInterface
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct SocialLoginRequestDTO: Encodable, Sendable {
    let provider: String?
    let authCode: String?
    let idToken: String?
    let redirectUri: String?
    let nickname: String?
    let email: String?
    
    public init(
        provider: String?,
        authCode: String?,
        idToken: String?,
        redirectUri: String?,
        nickname: String?,
        email: String?
    ) {
        self.provider = provider
        self.authCode = authCode
        self.idToken = idToken
        self.redirectUri = redirectUri
        self.nickname = nickname
        self.email = email
    }
}
