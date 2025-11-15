//
//  DeleteUserDefaultsUseCase.swift
//  UserDefaultsDomainInterface
//
//  Created by Auto on 11/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol DeleteUserDefaultsUseCase {
    func execute(_ type: UserDefaultsType)
}

