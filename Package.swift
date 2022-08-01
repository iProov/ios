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
            url: "https://github.com/iProov/ios/releases/download/9.5.0/iProov.xcframework.zip",
            checksum: "502abac5793cfef7e37d7fb9f500462e0e80c82ce2342de304c141d5f6e166a8"
        ),
        .binaryTarget(
            name: "SocketIO",
            url: "https://github.com/iProov/ios/releases/download/9.5.0/SocketIO.xcframework.zip",
            checksum: "721654107aa37f6fd7f1e614a676ea9c5b07719fb4e4eb910096ebe2f24590b0"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/9.5.0/Starscream.xcframework.zip",
            checksum: "c1b557b68ef8a093da8e230a949f60358682d210b6ba51fa55f6adeb8e29d05a"
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
