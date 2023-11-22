// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XTZSwiftKit",
    platforms: [.macOS(.v10_15),
                .iOS(.v13),
                .tvOS(.v13),
                .watchOS(.v6)],
    products: [
        .library(
            name: "XTZSwiftKit",
            targets: ["XTZSwiftKit"]),
        .library(name: "XTZNetworkingKit",
                 targets: ["XTZNetworkingKit"]),
        .library(
            name: "XTZCoreDataKit",
            targets: ["XTZCoreDataKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1")),
    ],
    targets: [
        .target(
            name: "XTZSwiftKit",
            dependencies: []),
        .target(
            name: "XTZNetworkingKit",
            dependencies: ["Alamofire"]),
        .target(
            name: "XTZCoreDataKit",
            dependencies: []),
        .testTarget(
            name: "XTZSwiftKitTests",
            dependencies: ["XTZSwiftKit"]),
        .testTarget(
            name: "XTZNetworkingKitTests",
            dependencies: ["XTZNetworkingKit"]),
        .testTarget(
            name: "XTZCoreDataKitTests",
            dependencies: ["XTZCoreDataKit"]),
    ]
)
