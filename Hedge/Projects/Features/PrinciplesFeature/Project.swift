import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "PrinciplesFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
