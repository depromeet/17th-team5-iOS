// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "Alamofire": .framework,
            "Swinject": .framework,
            "ComposableArchitecture": .framework
        ],
        baseSettings: Settings.settings(configurations: XCConfig.framework)
    )
#endif

let package = Package(
    name: "TestProject",
    platforms: [.iOS(.v17)],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.7.1"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.22.2"),
    ]
)
