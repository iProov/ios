// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "iProov",
    products: [
        .library(
            name: "iProov",
            targets: ["iProovWrapper"]
        ),
    ],
    dependencies: [
        .package(name: "SocketIO", url: "https://github.com/socketio/socket.io-client-swift", .upToNextMajor(from: "15.2.0")),
    ],
    targets: [
        .target(
            name: "iProovWrapper",
            dependencies: [
                .product(name: "SocketIO", package: "SocketIO"),
                .target(name: "iProov", condition: .when(platforms: .some([.iOS]))),
            ]
        ),
        .binaryTarget(
            name: "iProov",
            url: "https://github.com/iProov/ios/raw/master/iProov.xcframework.zip",
            checksum: "8a74fe24b65a783d5310db70002fdeca2c6ff38ecea0c9e58e85b0445de8f204"
        ),
    ]
)
