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
            url: "https://github.com/iProov/ios/releases/download/10.2.0-beta/iProov.xcframework.zip",
            checksum: "e2672fbecff085fc95b776ad5a1c40be2e3cdd3a3e29239bbda30da3accc5682"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://github.com/iProov/ios/releases/download/10.2.0-beta/Starscream.xcframework.zip",
            checksum: "62d66c34d26235de516a4f29bc0a8a34dd5b4769985ce06b6cca9abfc0c34293"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: .some([.iOS]))),
                .target(name: "Starscream", condition: .when(platforms: .some([.iOS]))),
            ],
            path: "iProovTargets"
        ),
    ]
)
