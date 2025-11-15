import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "SplashFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
