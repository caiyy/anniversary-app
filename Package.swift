// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JnDay2",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "JnDay2",
            targets: ["JnDay2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/6tail/lunar-swift.git", from: "1.1.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "JnDay2",
            dependencies: [.product(name: "LunarSwift", package: "lunar-swift")]),
        .testTarget(
            name: "JnDay2Tests",
            dependencies: ["JnDay2"]
        ),
    ]
)
