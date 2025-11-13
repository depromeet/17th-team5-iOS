//
//  GetUserDefaultsUseCase.swift
//  UserDefaultsDomainInterface
//
//  Created by Auto on 11/11/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public protocol GetUserDefaultsUseCase {
    func execute<T>(_ type: UserDefaultsType) -> T?
}

