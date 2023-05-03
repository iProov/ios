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
            url: "https://github.com/iProov/ios/releases/download/0.0.0/iProov.xcframework.zip",
            checksum: "e605543818299a0a9ab4d9fb7df8d4a18e79f8f00ffb22e4f854be993cfaa307"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/0.0.0/Starscream.xcframework.zip",
            checksum: "158e0fe12ae2f5833bd341c17a5524a6a857605bbe250658858825ab404f9c3e"
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
