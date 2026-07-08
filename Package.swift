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
            url: "https://github.com/iProov/ios/releases/download/13.2.0/iProov.xcframework.zip",
            checksum: "923def71bf1268953441264cc898e1786e892bdf6779a866256c16283e33da6f"
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
