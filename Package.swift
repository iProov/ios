// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "iProov",
    platforms: [
        .iOS(.v13),
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
            url: "https://github.com/iProov/ios/releases/download/12.4.1/iProov.xcframework.zip",
            checksum: "51dfd1d1d29c7df1dceaf8384637c632381965a310e0009ef025fdfdc6cfa056"
        ),
        .target(
            name: "iProovTargets",
            dependencies: [
                .target(name: "iProov", condition: .when(platforms: .some([.iOS]))),
            ],
            path: "iProovTargets",
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
