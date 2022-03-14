// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "iProov",
            targets: ["iProovFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/socketio/socket.io-client-swift", .upToNextMinor(from: "16.0.0"))
    ],
    targets: [
       .binaryTarget(
           name: "iProovFramework",
           path: "iProov.xcframework"
       ) 
    ]
)
