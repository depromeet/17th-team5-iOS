import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "TradeFeedbackFeature"),
    product: .staticFramework,
    dependencies: [
        .Core.core
    ]
)
