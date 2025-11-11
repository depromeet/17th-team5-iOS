import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "SelectPrincipleFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
