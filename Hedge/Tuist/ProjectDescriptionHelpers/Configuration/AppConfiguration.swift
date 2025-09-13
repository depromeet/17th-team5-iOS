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
    let shortVersion: String = "1.0.0"
    let bundleIdentifier: String = "com.depromeet.hedge"
    let displayName: String = "햇제"
    let destination: Set<Destination> = [.iPhone, .iPad]
    var entitlements: Entitlements? = nil
    let deploymentTarget: DeploymentTargets = .iOS("17.0")
    
    public var configurationName: ConfigurationName {
        return "Hedge"
    }
    
    var infoPlist: [String : Plist.Value] {
        InfoPlist.appInfoPlist(self)
    }
    
    public var autoCodeSigning: SettingsDictionary {
        return SettingsDictionary().automaticCodeSigning(devTeam: "DD8KP9C4KQ")
    }
    
    let commonSettings = Settings.settings(
        base: SettingsDictionary.debugSettings
            .configureAutoCodeSigning()
            .configureTestability(),
        configurations: XCConfig.framework
    )
}
