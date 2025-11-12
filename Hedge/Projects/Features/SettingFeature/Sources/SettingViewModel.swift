//
//  SettingViewModel.swift
//  SettingFeature
//
//  Created by Junyoung on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import AuthenticationServices
import Foundation

import AuthDomainInterface
import SettingFeatureInterface

public final class SettingViewModel: ObservableObject {
    @Published var presentAlert: Bool = false
    
    weak var coordinator: SettingCoordinator?
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension SettingViewModel {
    func popToPrev() {
        coordinator?.finish()
    }
    
    func withdrawTapped() {
        Task {
            try await withdraw()
        }
    }
    
    func logOutTapped() {
        authRepository.logOut()
        coordinator?.signOut()
    }
    
    private func withdraw() async throws {
        let type = authRepository.fetchSocialProvider()
        
        switch type {
        case .kakao:
            try await authRepository.withdraw(nil)
        case .apple:
            let handler = await AppleAuthenticationHandler()
            do {
                let authCode = try await handler.revokeAppleAccount()
                print("authCode: \(authCode)")
                try await authRepository.withdraw(authCode)
                coordinator?.signOut()
                
            } catch {
                print("Apple 회원탈퇴 실패: \(error.localizedDescription)")
            }
        case .google:
            return
        }
    }
}

class AppleAuthenticationHandler: NSObject, ASAuthorizationControllerDelegate {
    private var completion: ((Result<String, Error>) -> Void)?
    
    func revokeAppleAccount() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            self.completion = { result in
                continuation.resume(with: result)
            }
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = []
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let authorizationCode = appleIDCredential.authorizationCode,
               let tokenString = String(data: authorizationCode, encoding: .utf8) {
                completion?(.success(tokenString))
            } else {
                completion?(.failure(NSError(domain: "AppleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get identity token"])))
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
}
