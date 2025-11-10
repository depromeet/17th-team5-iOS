//
//  UserDataSource.swift
//  LocalDataSourceInterface
//
//  Created by Junyoung on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol UserDataSource {
    var loginType: String? { get }
    
    func updateLoginType(type: String)
}
