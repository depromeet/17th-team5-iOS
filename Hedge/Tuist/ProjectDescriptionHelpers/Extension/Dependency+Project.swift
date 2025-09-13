//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung Lee on 1/9/25.
//

import ProjectDescription

// MARK: - DataSource
public extension TargetDependency.Module {
    static let localDataSource = LocalDataSource.self
    static let remoteDataSource = RemoteDataSource.self
    
    struct LocalDataSource {
        public static let implement = dependency(
            target: "LocalDataSource",
            path: .relativeLocalDataSource()
        )
        
        public static let interface = dependency(
            target: "LocalDataSourceInterface",
            path: .relativeLocalDataSource()
        )
    }
    
    struct RemoteDataSource {
        public static let implement = dependency(
            target: "RemoteDataSource",
            path: .relativeRemoteDataSource()
        )
        
        public static let interface = dependency(
            target: "RemoteDataSourceInterface",
            path: .relativeRemoteDataSource()
        )
    }
}

public extension TargetDependency.Module {
    static let data = dependency(
        target: "Data",
        path: .relativeData()
    )
    
    static let repository = dependency(
        target: "Repository",
        path: .relativeRepository()
    )
    
    static let persistence = dependency(
        target: "Persistence",
        path: .relativePersistence()
    )
    
    static let shared = dependency(
        target: "Shared",
        path: .relativShared()
    )
    
    static let networker = dependency(
        target: "Networker",
        path: .relativeToNetwork()
    )
}

public extension TargetDependency.Core {
    static let designKit = dependency(
        target: "DesignKit",
        path: .relativeToCore(path: "DesignKit")
    )
    
    static let core = dependency(
        target: "Core",
        path: .relativeToCore(path: "Core")
    )
}

public extension TargetDependency.App {
    static let umbrella = dependency(
        target: "Umbrella",
        path: .relativeUmbrella()
    )
}
