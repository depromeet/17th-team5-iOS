//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung Lee on 1/9/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "RootFeature"),
    product: .staticFramework,
    dependencies: [
        .Feature.Home.feature,
        .Feature.StockSearch.feature,
        .Feature.TradeHistory.feature,
        .Feature.TradeFeedback.feature,
        .Feature.Principles.feature,
        .Feature.Login.feature,
        .Feature.PrincipleReview.feature,
        .Feature.Setting.feature,
        .Feature.AddPrinciple.feature,
        .Feature.SelectPrinciple.feature,
    ]
)
