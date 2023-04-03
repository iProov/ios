// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v10),
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
            url: "https://github.com/iProov/ios/releases/download/9.5.2/iProov.xcframework.zip",
            checksum: "3389e7a103c1c782a37637dae7c317718c1b4ef8261a1bb9be4e09239de760b9"
        ),
        .binaryTarget(
            name: "SocketIO",
            url: "https://github.com/iProov/ios/releases/download/9.5.2/SocketIO.xcframework.zip",
            checksum: "2950e7c585316a750feb2dbeeb911244fce860a79b693c7832d7d049936dd502"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/9.5.2/Starscream.xcframework.zip",
            checksum: "bd54cb23cd282d3b67f72c31ea7aee8475b2384761b1dfc8ba5d67e12fed8857"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: .some([.iOS]))),
                .target(name: "SocketIO", condition: .when(platforms: .some([.iOS]))),
                .target(name: "Starscream", condition: .when(platforms: .some([.iOS]))),
            ],
            path: "iProovTargets"
        ),
    ]
)
