// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v11),
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
            url: "https://github.com/iProov/ios/releases/download/10.1.2/iProov.xcframework.zip",
            checksum: "b0a5c9d29cb9835c41ccc81f8d12df7f1474dcccb04515572dab2ee6530447ce"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.1.2/Starscream.xcframework.zip",
            checksum: "6c253387dbfc4482a4dc4cf7680dd9234057ad5fc18d0b2f86d40ece6871370a"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: .some([.iOS]))),
                .target(name: "Starscream", condition: .when(platforms: .some([.iOS]))),
            ],
            path: "iProovTargets"
        ),
    ]
)
