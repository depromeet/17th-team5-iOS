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
    private let userDataSource: UserDataSource
    private let authDataSource: AuthDataSource
    
    public init(
        tokenDataSource: TokenDataSource,
        userDataSource: UserDataSource,
        authDataSource: AuthDataSource
    ) {
        self.tokenDataSource = tokenDataSource
        self.userDataSource = userDataSource
        self.authDataSource = authDataSource
    }
    
    public func social(
        provider: AuthDomainInterface.SocialProvider,
        code: String,
        email: String?,
        nickname: String?
    ) async throws {
        let request = SocialLoginRequestDTO(
            provider: provider.rawValue,
            authCode: provider == .apple ? code : nil,
            idToken: provider == .kakao ? code : nil,
            redirectUri: nil,
            nickname: nickname,
            email: email
        )
        
        let response = try await authDataSource.social(request)
        let token = AuthToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
        userDataSource.updateLoginType(type: provider.rawValue)
        tokenDataSource.updateToken(token: token)
    }
    
    public func isAuthorized() -> Bool {
        return tokenDataSource.accessToken != nil
    }
    
    public func fetchSocialProvider() -> SocialProvider {
        SocialProvider(from: userDataSource.loginType)
    }
    
    public func withdraw(_ code: String?) async throws {
        let request = AuthCodeRequestDTO(authCode: code)
        return try await authDataSource.withdraw(request)
    }
}
