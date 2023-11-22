// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XTZSwiftKit",
    platforms: [.macOS(.v10_15),
                .iOS(.v13),
                .tvOS(.v13),
                .watchOS(.v6)],
    products: [
        .library(name: "XTZNetworkingKit",
                 targets: ["XTZNetworkingKit"]),
        .library(
            name: "XTZSwiftKit",
            targets: ["XTZSwiftKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1")),
    ],
    targets: [
        .target(
            name: "XTZNetworkingKit",
            dependencies: ["Alamofire"]),
        .target(
            name: "XTZSwiftKit"),
        .testTarget(
            name: "XTZNetworkingKitTests",
            dependencies: ["XTZNetworkingKit"]),
        .testTarget(
            name: "XTZSwiftKitTests",
            dependencies: ["XTZSwiftKit"]),
    ]
)
