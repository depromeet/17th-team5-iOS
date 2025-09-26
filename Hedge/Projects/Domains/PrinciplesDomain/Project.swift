import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "PrinciplesDomain"),
    product: .staticFramework,
    dependencies: [
        .Module.shared
    ],
    hasInterface: true,
    hasTests: true
)