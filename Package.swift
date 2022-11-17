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
            url: "https://github.com/iProov/ios/releases/download/10.0.0/iProov.xcframework.zip",
            checksum: "2dfd539cca4612b1db666d19eaac355fb750953dc60ffb75fd4005ab2a82e939"
        ),
        .binaryTarget(
            name: "SwiftProtobuf",
            url: "https://github.com/iProov/ios/releases/download/10.0.0/SwiftProtobuf.xcframework.zip",
            checksum: "cc5983f843f4d85c4db89ec9fb393b01ebc92ebce8b0705c32ecd3e6c4b95284"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.0.0/Starscream.xcframework.zip",
            checksum: "058c0d9826e77145596f2e12695532725a657703d8cff595313de7ae3def2f71"
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
