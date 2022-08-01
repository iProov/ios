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
            url: "https://github.com/iProov/ios/releases/download/9.5.1/iProov.xcframework.zip",
            checksum: "3332415af3e2d6bea1b70c432a58dd2676539bce7fec4e73f75c10e921b837b3"
        ),
        .binaryTarget(
            name: "SocketIO",
            url: "https://github.com/iProov/ios/releases/download/9.5.1/SocketIO.xcframework.zip",
            checksum: "9486cf260a682f5869368498761cc9318a671e5039a4e283f5c97f4a785d54c1"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/9.5.1/Starscream.xcframework.zip",
            checksum: "9da3b5390372a868120452b27720fc65d0086677f0abe075cbfc7c3cb18875de"
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
