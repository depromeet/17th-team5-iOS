import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "AddPrincipleFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
