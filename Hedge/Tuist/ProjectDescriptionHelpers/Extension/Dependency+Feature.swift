//
//  Dependency+Feature.swift
//  Config
//
//  Created by Junyoung Lee on 1/21/25.
//

import ProjectDescription

public extension TargetDependency.Feature {
    struct Root {
        private static let name = "RootFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct Home {
        private static let name = "HomeFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct Retrospect {
        private static let name = "RetrospectFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct TradeReason {
        private static let name = "TradeReasonFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct TradeHistory {
        private static let name = "TradeHistoryFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
}
