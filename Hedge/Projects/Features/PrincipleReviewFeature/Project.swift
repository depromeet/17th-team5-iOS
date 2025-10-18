import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "PrincipleReviewFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
