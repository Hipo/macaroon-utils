// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MacaroonUtils",
    platforms: [.iOS(.v11), .macOS(.v10_15)],
    products: [
        .library(name: "MacaroonUtils", targets: ["MacaroonUtils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Square/Valet.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(name: "MacaroonUtils", dependencies: ["Valet"]),
        .testTarget(name: "MacaroonUtilsTests", dependencies: ["MacaroonUtils"]),
    ]
)
