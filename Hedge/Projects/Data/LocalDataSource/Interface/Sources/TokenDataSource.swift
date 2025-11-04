//
//  TokenDataSource.swift
//  LocalDataSource
//
//  Created by Junyoung on 10/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import AuthDomainInterface

public protocol TokenDataSource {
    var accessToken: String? { get }
    
    func updateToken(token: AuthToken)
    func clear()
}
