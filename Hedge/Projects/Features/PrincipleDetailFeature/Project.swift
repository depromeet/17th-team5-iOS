import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "PrincipleDetailFeature"),
    product: .staticFramework,
    dependencies: [
        .Core.core,
    ]
)
