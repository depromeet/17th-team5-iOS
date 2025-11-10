//
//  DefaultUserDataSource.swift
//  LocalDataSourceInterface
//
//  Created by Junyoung on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Persistence
import LocalDataSourceInterface

public struct DefaultUserDataSource: UserDataSource {
    private let userPersistence: UserPersistence
    
    public init(userPersistence: UserPersistence) {
        self.userPersistence = userPersistence
    }
    
    public var loginType: String? {
        userPersistence.getLoginType()
    }
    
    public func updateLoginType(type: String) {
        userPersistence.saveLoginType(type)
    }
}
