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
import DesignKit

public struct LoginView: View {
    @StateObject var container: MVIContainer<LoginIntentProtocol, LoginModelProtocol>
    
    private var state: LoginModelProtocol { container.model }
    private var intent: LoginIntentProtocol { container.intent } 
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            VStack(spacing: 20) {
                Image.hedgeUI.logo
                    .resizable()
                    .frame(width: 112, height: 124)
                
                Text("AI 피드백을 통해 나만의\n투자 원칙을 만드는 투자 회고 서비스")
                    .multilineTextAlignment(.center)
                    .font(.body1Semibold)
                    .foregroundStyle(Color.hedgeUI.textPrimary)
            }
            
            VStack(spacing: 12) {
                Spacer()
                
                appleLoginButton
                    .frame(height: 57)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
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
