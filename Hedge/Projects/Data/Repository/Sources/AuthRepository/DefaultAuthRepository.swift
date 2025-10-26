//
//  DefaultAuthRepository.swift
//  Repository
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import AuthDomainInterface
import LocalDataSourceInterface
import RemoteDataSourceInterface

public final class DefaultAuthRepository: AuthRepository {
    private let tokenDataSource: TokenDataSource
    private let authDataSource: AuthDataSource
    
    public init(
        tokenDataSource: TokenDataSource,
        authDataSource: AuthDataSource
    ) {
        self.tokenDataSource = tokenDataSource
        self.authDataSource = authDataSource
    }
    
    public func social(
        provider: AuthDomainInterface.SocialProvider,
        authCode: String,
        email: String?,
        nickname: String?
    ) async throws {
        let request = SocialLoginRequestDTO(
            provider: provider.rawValue,
            authCode: authCode,
            redirectUri: "",
            nickname: nickname,
            email: email
        )
        
        let response = try await authDataSource.social(request)
        let token = AuthToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
        tokenDataSource.updateToken(token: token)
    }
    
    public func isAuthorized() -> Bool {
        return tokenDataSource.accessToken != nil
    }
}
