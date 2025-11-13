//
//  SaveUserDefaults.swift
//  UserDefaultsDomain
//
//  Created by Auto on 11/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import UserDefaultsDomainInterface

public struct SaveUserDefaults: SaveUserDefaultsUseCase {
    
    public init() {}
    
    public func execute<T>(value: T, _ type: UserDefaultsDomainInterface.UserDefaultsType) {
        UserDefaults.standard.set(value, forKey: type.rawValue)
    }
}

