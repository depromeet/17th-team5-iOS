// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "Alamofire": .framework,
            "Swinject": .framework,
            "ComposableArchitecture": .framework,
            "Kingfisher": .framework
        ],
        baseSettings: Settings.settings(configurations: XCConfig.library)
    )
#endif

let package = Package(
    name: "TestProject",
    platforms: [.iOS(.v17)],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.10.2"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.22.2"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "8.5.0"),
    ]
)
