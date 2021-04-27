// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Log",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "Log",
            targets: ["Log"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", .upToNextMajor(from: "1.4.2"))
    ],
    targets: [
        .target(
            name: "Log",
            dependencies: []),
        .testTarget(
            name: "LogTests",
            dependencies: ["Log"]),
    ]
)
