//
//  DIContainer.swift
//  Shared
//
//  Created by Junyoung on 9/7/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Swinject

public enum DIContainer: Sendable {
    
    public static let container = Container()
    
    public static func register(assemblies: [Assembly]) {
        assemblies.forEach { assembly in
            assembly.assemble(container: container)
        }
    }
    
    public static func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("Could not resolve \(type)")
        }
        return resolved
    }
}
