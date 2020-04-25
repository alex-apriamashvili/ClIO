// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Names

import PackageDescription

private let packageName = "ClIO"
private let testTargetName = "ClIOTests"

// MARK: - External Packages

private let xctAssertResultDependency =
  Package.Dependency.package(
    url: "https://github.com/alex-apriamashvili/XCTAssertResult.git",
    .upToNextMajor(from: "0.0.1")
)

// MARK: - Package Definition

let package = Package(
    name: packageName,
    products: [
      .library(name: packageName, targets: [packageName])
    ],
    dependencies: [
      xctAssertResultDependency
    ],
    targets: [
        .target(name: packageName),
        .testTarget(
          name: testTargetName,
          dependencies: ["ClIO", "XCTAssertResult"]
        )
    ]
)
