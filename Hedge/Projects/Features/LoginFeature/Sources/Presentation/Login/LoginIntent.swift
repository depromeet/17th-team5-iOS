//
//  LoginIntent.swift
//  LoginFeature
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import AuthenticationServices

import LoginFeatureInterface
import Shared
import AuthDomainInterface

public struct LoginIntent: LoginIntentProtocol {
    private let authRepository: AuthRepository
    public weak var coordinator: LoginCoordinator?
    
    private var model: LoginModelProtocol
    
    public init(
        model: LoginModelProtocol,
        authRepository: AuthRepository
    ) {
        self.model = model
        self.authRepository = authRepository
    }
    
    public func appleLoginSuccess(_ response: ASAuthorization) {
        guard let credential = response.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCode = credential.authorizationCode,
              let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else {
            Log.error("apple login casting error")
            return
        }
        
        Task {
            do {
                try await authRepository.social(
                    provider: .apple,
                    authCode: authorizationCodeString,
                    redirectUri: "com.og.hedge",
                    email: credential.email,
                    nickname: credential.fullName?.nickname
                )
                coordinator?.finish()
            } catch {
                Log.error("login failure server: \(error)")
            }
        }
        
        Log.debug(authorizationCodeString)
        
    }
    
    public func appleLoginFailure(_ error: any Error) {
        Log.error("apple login failure: \(error.localizedDescription)")
    }
}
