import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "TradeHistoryFeature"),
    product: .staticFramework,
    dependencies: [
	.Core.core
    ]
)
