// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Log",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Log",
            targets: ["Log"])
    ],
    targets: [
        .target(
            name: "Mongoose",
            path: "Sources/Log/Framework/Mongoose"),
        .target(
            name: "Log",
            dependencies: ["Mongoose"],
            path: "Sources/Log",
            exclude: ["Framework"],
            resources: [.process("Other")],
            swiftSettings: [
                .define("RELEASE", .when(configuration: .release)),
                .define("DEBUG", .when(configuration: .debug)),
            ]),
        .testTarget(
            name: "LogTests",
            dependencies: ["Log"])
    ]
)
