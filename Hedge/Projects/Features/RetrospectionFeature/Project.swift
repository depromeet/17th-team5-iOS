import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "RetrospectionFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
