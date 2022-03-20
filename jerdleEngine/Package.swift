// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "jerdleEngine",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "jerdleEngine",
            targets: ["jerdleEngine"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "jerdleEngine",
            dependencies: [],
            path: "jerdleEngine"),
        .testTarget(
            name: "jerdleEngineTests",
            dependencies: ["jerdleEngine"],
            path: "jerdleEngineTests"),
    ]
)
