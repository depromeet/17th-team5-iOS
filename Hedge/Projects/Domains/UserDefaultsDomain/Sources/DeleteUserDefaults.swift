//
//  DeleteUserDefaults.swift
//  UserDefaultsDomain
//
//  Created by Auto on 11/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

import UserDefaultsDomainInterface

public struct DeleteUserDefaults: DeleteUserDefaultsUseCase {
    
    public init() {}
    
    public func execute(_ type: UserDefaultsDomainInterface.UserDefaultsType) {
        UserDefaults.standard.removeObject(forKey: type.rawValue)
    }
}

