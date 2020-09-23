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
            checksum: "b4850c4b9a4992fab1f53f2f26ac35a091de9531620fa110b1d2d278ea615824"
        ),
    ]
)
