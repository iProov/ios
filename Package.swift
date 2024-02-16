// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v12),
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
            url: "https://github.com/iProov/ios/releases/download/11.0.3/iProov.xcframework.zip",
            checksum: "6da33ee7eb224083a0565d4d6a1663025e51d9677d536db93fe6ab8b39d783cf"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: .some([.iOS]))),
            ],
            path: "iProovTargets"
        ),
    ]
)
