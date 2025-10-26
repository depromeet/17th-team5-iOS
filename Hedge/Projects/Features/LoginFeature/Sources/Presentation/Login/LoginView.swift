//
//  LoginView.swift
//  LoginFeature
//
//  Created by Junyoung on 10/25/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import AuthenticationServices

import Core
import LoginFeatureInterface

public struct LoginView: View {
    @StateObject var container: MVIContainer<LoginIntentProtocol, LoginModelProtocol>
    
    private var state: LoginModelProtocol { container.model }
    private var intent: LoginIntentProtocol { container.intent } 
    
    public var body: some View {
        VStack {
            appleLoginButton
        }
    }
}

private extension LoginView {
    var appleLoginButton: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
            case .success(let response):
                intent.appleLoginSuccess(response)
            case .failure(let error):
                intent.appleLoginFailure(error)
            }
        }
    }
}
