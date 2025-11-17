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
            url: "https://github.com/iProov/ios/releases/download/13.1.0/iProov.xcframework.zip",
            checksum: "e55f10505dd4346ca7e266c2e60d804b933e1ec04c1958e1c97af7644acf52f1"
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
