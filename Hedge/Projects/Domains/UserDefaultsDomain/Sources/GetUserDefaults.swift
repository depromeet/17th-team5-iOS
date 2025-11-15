//
//  GetUserDefaults.swift
//  UserDefaultsDomain
//
//  Created by Auto on 11/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import UserDefaultsDomainInterface

public struct GetUserDefaults: GetUserDefaultsUseCase {
    
    public init() {}
    
    public func execute<T>(_ type: UserDefaultsDomainInterface.UserDefaultsType) -> T? {
        let value = UserDefaults.standard.integer(forKey: type.rawValue)
        return value as? T
    }
}

