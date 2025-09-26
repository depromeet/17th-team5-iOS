//
//  Principles.swift
//  PrinciplesDomain
//
//  Created by 이중엽 on 9/26/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import Foundation

public struct Principle: Equatable, Hashable {
    public let id: Int
    public let principle: String
    
    public init(id: Int, principle: String) {
        self.id = id
        self.principle = principle
    }
}
