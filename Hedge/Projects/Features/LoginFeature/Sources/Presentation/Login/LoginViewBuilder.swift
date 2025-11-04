//
//  LoginViewBuilder.swift
//  LoginFeature
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import Core
import AuthDomainInterface
import LoginFeatureInterface

public struct LoginViewBuilder: LoginBuilderProtocol {
    public func build(
        coordinator: LoginCoordinator? = nil,
        authRepository: AuthRepository
    ) async -> any View {
        let model = await LoginModel()
        
        var intent = LoginIntent(
            model: model,
            authRepository: authRepository
        )
        intent.coordinator = coordinator
        
        let container = MVIContainer(
            intent: intent as LoginIntentProtocol,
            model: model as LoginModelProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return LoginView(container: container)
    }
}
