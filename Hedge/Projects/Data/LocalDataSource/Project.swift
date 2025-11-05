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
        // Note: Persistence module exists but is empty/placeholder
        // LocalDataSource uses UserDefaults directly (matches existing pattern)
        .Core.core,
        .Domain.Trade.interface
    ],
    hasInterface: true
)
