// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "iProov",
            targets: ["iProovTargets"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "iProov",
            url: "https://github.com/iProov/ios/releases/download/14.0.0/iProov.xcframework.zip",
            checksum: "27304324f5b65be451afeae08d18249a7385ec35b06f99af047dc6de6d2ef20b"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: [.iOS])),
            ],
            path: "iProovTargets",
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
