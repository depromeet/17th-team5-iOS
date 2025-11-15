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

    struct Principles {
        private static let name = "PrinciplesDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }

    struct Feedback {
        private static let name = "FeedbackDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }

    struct Analysis {
        private static let name = "AnalysisDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }
    
    struct Auth {
        private static let name = "AuthDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }
    
    struct Link {
        private static let name = "LinkDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }

    struct Retrospection {
        private static let name = "RetrospectionDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }

    struct UserDefaults {
        private static let name = "UserDefaultsDomain"
        public static let implement = domainDependency(target: name)
        public static let interface = domainInterfaceDependency(target: name)
    }
}
