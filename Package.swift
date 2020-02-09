// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let packageName = "ClIO"
private let testTargetName = "ClIOTests"
private let mainTargetDependency = Target.Dependency.init(stringLiteral: packageName)

private let xctAssertResult = "XCTAssertResult"
private let xctAssertResultRepo = "https://github.com/alex-apriamashvili/\(xctAssertResult).git"
private let xctAssertDependency = Target.Dependency.init(stringLiteral: xctAssertResult)
private let xctAssertResultDependency = Package.Dependency.package(
  url: xctAssertResultRepo,
  .upToNextMajor(from: Version(0, 0, 1))
)

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
        .testTarget(name: testTargetName, dependencies: [mainTargetDependency, xctAssertDependency])
    ]
)
