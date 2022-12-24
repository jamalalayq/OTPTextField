// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "OTPTextField",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "OTPTextField",
            targets: ["OTPTextField"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "OTPTextField",
            dependencies: []
        ),
        .testTarget(
            name: "OTPTextFieldTests",
            dependencies: ["OTPTextField"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
