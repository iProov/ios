// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v16),
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
            url: "https://github.com/iProov/ios/releases/download/14.1.0/iProov.xcframework.zip",
            checksum: "d47c41ae791aa8e3800551fde708f0b25a80b873ea423e76072838e679eb9625"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: [.iOS])),
            ],
            path: "iProovTargets",
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
