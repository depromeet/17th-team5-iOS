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
    
    struct StockSearch {
        private static let name = "StockSearchFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct TradeHistory {
        private static let name = "TradeHistoryFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct TradeFeedback {
        private static let name = "TradeFeedbackFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }

    struct Principles {
        private static let name = "PrinciplesFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct Login {
        private static let name = "LoginFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
    
    struct PrincipleReview {
        private static let name = "PrincipleReviewFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }

    struct Setting {
        private static let name = "SettingFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }

    struct Retrospection {
        private static let name = "RetrospectionFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }

    struct Splash {
        private static let name = "SplashFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }

    struct PrincipleDetail {
        private static let name = "PrincipleDetailFeature"
        public static let feature = featureDependency(target: name)
        public static let interface = featureInterfaceDependency(target: name)
    }
}
