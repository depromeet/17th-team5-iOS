//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/9/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "LocalDataSource"),
    product: .staticFramework,
    dependencies: [
        .Module.persistence
    ],
    hasInterface: true
)
