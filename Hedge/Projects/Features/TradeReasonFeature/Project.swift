import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "TradeReasonFeature"),
    product: .staticFramework,
    dependencies: [
        .Core.core
    ], interfaceDependencies: [
        .Feature.Principles.interface
    ]
)
