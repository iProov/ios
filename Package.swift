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
            url: "https://github.com/iProov/ios/releases/download/10.1.0/iProov.xcframework.zip",
            checksum: "190990013dfc2633bae543fe0fa54096cf702d39bf37f1280aa046dad4fb0a02"
        ),
        .binaryTarget(
            name: "SwiftProtobuf",
            url: "https://github.com/iProov/ios/releases/download/10.1.0/SwiftProtobuf.xcframework.zip",
            checksum: "5d7271ef5877bc3a8725400abeec2194c0c36c199edf14e351cd5c9e85411800"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.1.0/Starscream.xcframework.zip",
            checksum: "7c4b4e51f9a33abf3087de0cf9ecd20d2cac185231f89eccf981c5c93b0aaf68"
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
