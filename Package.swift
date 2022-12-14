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
            url: "https://github.com/iProov/ios/releases/download/10.1.1/iProov.xcframework.zip",
            checksum: "267c76c9b2ac179d103f7d343dc7068d24c14e7c8b8f0ef0ca6d70411747af10"
        ),
        .binaryTarget(
            name: "SwiftProtobuf",
            url: "https://github.com/iProov/ios/releases/download/10.1.1/SwiftProtobuf.xcframework.zip",
            checksum: "8719f2a66533c55c6f50bb2bbef811b09d1f623edabd6c4683ac8684732bccdd"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.1.1/Starscream.xcframework.zip",
            checksum: "6c55173d041b2549141e266786b745b88ae4939f730ce9bb1c350e9cedc2564b"
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
