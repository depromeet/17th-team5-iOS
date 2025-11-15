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
            logoView
            loginButtons
        }
    }
}

private extension LoginView {
    var logoView: some View {
        VStack(spacing: 20) {
            Image.hedgeUI.logoLarge
            
            Text("AI 피드백을 통해 나만의\n투자 원칙을 만드는 투자 회고 서비스")
                .multilineTextAlignment(.center)
                .font(.body1Semibold)
                .foregroundStyle(Color.hedgeUI.textPrimary)
        }
    }
    
    var loginButtons: some View {
        VStack(spacing: 12) {
            Spacer()
            kakaoLoginButton
            appleLoginButton
                
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
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
        .frame(height: 57)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    var kakaoLoginButton: some View {
        Button {
            intent.kakaoLoginTapped()
        } label: {
            HStack {
                Spacer()
                Image.hedgeUI.kakaologo
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("카카오로 시작하기")
                    .font(.body1Semibold)
                    .foregroundStyle(
                        Color(uiColor: UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0))
                    )
                Spacer()
            }
            .frame(height: 57)
            .background(
                Color(uiColor: UIColor(red: 254/255, green: 229/255, blue: 0/255, alpha: 1.0))
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}
