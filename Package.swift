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
            url: "https://github.com/iProov/ios/releases/download/10.0.1/iProov.xcframework.zip",
            checksum: "555b38fe48404b4b9a98ef7d02fdf4702ca6ee5537a088260213000d82d85356"
        ),
        .binaryTarget(
            name: "SwiftProtobuf",
            url: "https://github.com/iProov/ios/releases/download/10.0.1/SwiftProtobuf.xcframework.zip",
            checksum: "68ad8c6d7f7e132d4f6cd8d634dd3c5a9e4dd4335ad8e946cc9462fda1f219de"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.0.1/Starscream.xcframework.zip",
            checksum: "a9d29c3fe0f00a6abc64dea417f5a223d87caedfc22cebad85024645ae976a00"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: .some([.iOS]))),
                .target(name: "SwiftProtobuf", condition: .when(platforms: .some([.iOS]))),
                .target(name: "Starscream", condition: .when(platforms: .some([.iOS]))),
            ],
            path: "iProovTargets"
        ),
    ]
)
