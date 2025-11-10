//
//  UserPersistence.swift
//  Persistence
//
//  Created by Junyoung on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public final class UserPersistence {
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    private enum LoinKeys: String {
        case loginType = "loginType"
    }
    
    public func saveLoginType(_ type: String) {
        userDefaults.set(type, forKey: LoinKeys.loginType.rawValue)
    }
    
    public func getLoginType() -> String? {
        userDefaults.string(forKey: LoinKeys.loginType.rawValue)
    }
}
