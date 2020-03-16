// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ErrorAssertions",
    products: [
        .library(name: "ErrorAssertions", targets: ["ErrorAssertions"]),
        .library(name: "ErrorAssertionExpectations",
                 targets: ["ErrorAssertionExpectations"]),
    ],
    targets: [
        .target(name: "ErrorAssertions", dependencies: []),
        .target(name: "ErrorAssertionExpectations",
                dependencies: ["ErrorAssertions"]),
        .testTarget(name: "ErrorAssertionsTests",
                    dependencies: [
                        "ErrorAssertions",
                        "ErrorAssertionExpectations",
            ]),
    ],
    swiftLanguageVersions: [
        .version("4"),
        .version("4.2"),
        .version("5")
    ]
)
