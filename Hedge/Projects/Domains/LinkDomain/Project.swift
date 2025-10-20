import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "LinkDomain"),
    product: .staticFramework,
    dependencies: [
        .Module.shared
    ],
    hasInterface: true,
    hasTests: true
)