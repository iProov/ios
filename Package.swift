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
            url: "https://github.com/iProov/ios/releases/download/11.0.0/iProov.xcframework.zip",
            checksum: "59cc77b08836ebfd70049271c6c6a841fa702021ea15670e3daa11f22acd9f29"
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
