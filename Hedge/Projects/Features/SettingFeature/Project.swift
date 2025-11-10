import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "SettingFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
