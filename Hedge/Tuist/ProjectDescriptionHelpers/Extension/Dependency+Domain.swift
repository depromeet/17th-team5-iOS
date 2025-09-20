//
//  Dependency+Domain.swift
//  Config
//
//  Created by Junyoung Lee on 1/21/25.
//

import ProjectDescription

public extension TargetDependency.Domain {
    struct Stock {
        private static let name = "StockDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }
}
