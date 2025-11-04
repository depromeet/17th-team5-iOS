import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .micro(name: "LoginFeature"),
    product: .staticFramework,
    dependencies: [
        .Core.core,
        .Library.kakaoSDKUser
    ]
)
