// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlowView",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "FlowView",
            targets: ["FlowView"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FlowView",
            dependencies: []),
        .testTarget(
            name: "FlowViewTests",
            dependencies: ["FlowView"]),
    ],
    swiftLanguageVersions: [.v5]
)
