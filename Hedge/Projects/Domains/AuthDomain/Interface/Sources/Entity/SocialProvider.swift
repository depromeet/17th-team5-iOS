//
//  SocialProvider.swift
//  AuthDomain
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public enum SocialProvider: String {
    case apple = "APPLE"
    case google = "GOOGLE"
    case kakao = "KAKAO"
    
    public init(from value: String?) {
        self = .init(rawValue: value ?? "") ?? .kakao
    }
}
