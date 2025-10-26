//
//  LoginIntentProtocol.swift
//  LoginFeature
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import AuthenticationServices

public protocol LoginIntentProtocol {
    func appleLoginSuccess(_ response: ASAuthorization)
    func appleLoginFailure(_ error: Error)
}
