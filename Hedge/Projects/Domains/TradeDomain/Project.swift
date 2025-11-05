
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "TradeDomain"),
    product: .staticFramework,
    dependencies: [
        .Module.shared,
        .Core.core
    ],
    hasInterface: true,
    hasTests: true
)

