//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/19/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "Umbrella"),
    product: .framework,
    dependencies: [
        .Feature.Root.feature,
        .Module.data,
        .Domain.Trade.implement // DomainAssembly imports TradeDomain implementation
    ],
    hasTests: false
)
