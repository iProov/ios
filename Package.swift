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
            url: "https://github.com/iProov/ios/releases/download/9.4.0/iProov.xcframework.zip",
            checksum: "5425cfc5478e89442c91962489548e9531dbd6f460b0112cb235162a4e7b16f7"
        ),
        .binaryTarget(
            name: "SocketIO",
            url: "https://github.com/iProov/ios/releases/download/9.4.0/SocketIO.xcframework.zip",
            checksum: "e87bbf570db779e9a0a9114bcd58da6312a2ef174c8d41e7471ba884ef3933e8"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/9.4.0/Starscream.xcframework.zip",
            checksum: "9203f6e650623ec01c2c333505e89d5a10cb1cd7194cf7abb5318342013bdfc1"
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
