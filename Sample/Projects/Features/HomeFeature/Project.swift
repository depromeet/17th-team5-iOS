import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "HomeFeature"),
    product: .staticFramework,
    dependencies: [
        .Core.core
    ]
)
