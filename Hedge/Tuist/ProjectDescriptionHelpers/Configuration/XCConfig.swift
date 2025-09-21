//
//  XCConfig.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import ProjectDescription

public struct XCConfig {
    private struct Path {
        static var framework: ProjectDescription.Path {
            .relativeToRoot("xcconfigs/targets/iOS-Framework.xcconfig")
        }
        
        static var library: ProjectDescription.Path {
            .relativeToRoot("xcconfigs/targets/iOS-Library.xcconfig")
        }
        
        static var tests: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Tests.xcconfig")
        }
    }
    
    public static let framework: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.framework),
        .release(name: "Production", xcconfig: Path.framework),
    ]
    
    public static let library: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.library),
        .release(name: "Production", xcconfig: Path.library),
    ]
    
    public static let tests: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.tests),
        .release(name: "Production", xcconfig: Path.tests),
    ]
}
