import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "StockDomain"),
    product: .staticFramework,
    dependencies: [
        .Module.shared
    ],
    hasInterface: true,
    hasTests: true
)
