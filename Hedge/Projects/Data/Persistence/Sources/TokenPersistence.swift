//
//  TokenPersistence.swift
//  Persistence
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public final class TokenPersistence {
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    private enum TokenKeys: String {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    // MARK: - Access Token
    
    public func saveAccessToken(_ token: String) {
        userDefaults.set(token, forKey: TokenKeys.accessToken.rawValue)
    }
    
    public func getAccessToken() -> String? {
        return userDefaults.string(forKey: TokenKeys.accessToken.rawValue)
    }
    
    // MARK: - Refresh Token
    
    public func saveRefreshToken(_ token: String) {
        userDefaults.set(token, forKey: TokenKeys.refreshToken.rawValue)
    }
    
    public func getRefreshToken() -> String? {
        return userDefaults.string(forKey: TokenKeys.refreshToken.rawValue)
    }
    
    // MARK: - Clear
    
    public func clearTokens() {
        userDefaults.removeObject(forKey: TokenKeys.accessToken.rawValue)
        userDefaults.removeObject(forKey: TokenKeys.refreshToken.rawValue)
    }
}
