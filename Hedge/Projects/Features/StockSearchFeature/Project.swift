import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "StockSearchFeature"),
    product: .staticFramework,
    dependencies: [
        .Core.core
    ]
)
