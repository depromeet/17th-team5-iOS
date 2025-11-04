//
//  LoginBuilderProtocol.swift
//  LoginFeature
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import AuthDomainInterface

public protocol LoginBuilderProtocol {
    func build(coordinator: LoginCoordinator?, authRepository: AuthRepository) async -> any View
}
