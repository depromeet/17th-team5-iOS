//
//  DefaultTokenDataSource.swift
//  LocalDataSource
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import LocalDataSourceInterface
import AuthDomainInterface
import Persistence

public struct DefaultTokenDataSource: TokenDataSource {
    private let tokenPersistence: TokenPersistence
    
    public init(tokenPersistence: TokenPersistence) {
        self.tokenPersistence = tokenPersistence
    }
    
    public var accessToken: String? {
        return tokenPersistence.getAccessToken()
    }
    
    public func updateToken(token: AuthToken) {
        tokenPersistence.saveAccessToken(token.accessToken)
        tokenPersistence.saveRefreshToken(token.refreshToken)
    }
    
    public func clear() {
        tokenPersistence.clearTokens()
    }
}
