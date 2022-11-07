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
            url: "https://github.com/iProov/ios/releases/download/10.0.0-beta/iProov.xcframework.zip",
            checksum: "265ca3becf1ca94add235cf376260efe5dabe49dde5dd1ad8bb1945531bccf0c"
        ),
        .binaryTarget(
            name: "SwiftProtobuf",
            url: "https://github.com/iProov/ios/releases/download/10.0.0-beta/SwiftProtobuf.xcframework.zip",
            checksum: "1dc1fabd3065f2e294bc87d80940d12f5f022996696bee33068531ba43ab5643"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.0.0-beta/Starscream.xcframework.zip",
            checksum: "5872eb3805132e9aa2d95624fce432b04d808410faa24e1f3e52b615db474acd"
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
