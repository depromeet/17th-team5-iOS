//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/9/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "RemoteDataSource"),
    product: .staticFramework,
    dependencies: [
        .Module.networker,
        .Domain.Stock.interface,
        .Domain.Principles.interface,
        .Domain.Feedback.interface,
        .Domain.Analysis.interface,
        .Domain.Link.interface,
    ],
    hasInterface: true
)
