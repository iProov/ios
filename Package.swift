// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v15),
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
            url: "https://github.com/iProov/ios/releases/download/13.2.1/iProov.xcframework.zip",
            checksum: "11d5db963e0e2efa7ad753310ec6d96ce4c937cd5a7141657196c11dec50385a"
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
