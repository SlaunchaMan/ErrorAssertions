// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ErrorAssertions",
    products: [
        .library(name: "ErrorAssertions", targets: ["ErrorAssertions"]),
    ],
    targets: [
        .target(name: "ErrorAssertions", dependencies: []),
        .testTarget(name: "ErrorAssertionsTests",
                    dependencies: ["ErrorAssertions"]),
    ]
)
