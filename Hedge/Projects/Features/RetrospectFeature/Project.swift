import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "RetrospectFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
