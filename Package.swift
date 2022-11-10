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
            url: "https://github.com/iProov/ios/releases/download/10.0.0-beta2/iProov.xcframework.zip",
            checksum: "dda6ce48e1043bc2b2922209285bfb3840f7a75ac41df01f7578974bbe7ccbd3"
        ),
        .binaryTarget(
            name: "SwiftProtobuf",
            url: "https://github.com/iProov/ios/releases/download/10.0.0-beta2/SwiftProtobuf.xcframework.zip",
            checksum: "9a34ec9f4a3c5b3f8b8dd58514ab8f0c03060962ee55ccb2065d257772fa2717"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.0.0-beta2/Starscream.xcframework.zip",
            checksum: "3fd899e7637114ed24e7b6c21bd4ecf6b7e76804358851896a0dd83b66915a50"
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
