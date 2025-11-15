//
//  AppConfiguration.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import Foundation
import ProjectDescription

public struct AppConfiguration {
    
    public init() {}
    
    let workspaceName = "Hedge"
    let projectName: String = "Hedge"
    let organizationName = "HedgeCompany"
    let shortVersion: String = "1.0.2"
    let bundleIdentifier: String = "com.og.hedge"
    let displayName: String = "햇제"
    let destination: Set<Destination> = [.iPhone]
    var entitlements: Entitlements? = "Hedge.entitlements"
    let deploymentTarget: DeploymentTargets = .iOS("17.0")
    
    public var configurationName: ConfigurationName {
        return "Hedge"
    }
    
    var infoPlist: [String : Plist.Value] {
        InfoPlist.appInfoPlist(self)
    }
    
    let commonSettings = Settings.settings(
        base: SettingsDictionary.debugSettings
            .configureAutoCodeSigning()
            .configureTestability(),
        configurations: XCConfig.framework
    )
}
