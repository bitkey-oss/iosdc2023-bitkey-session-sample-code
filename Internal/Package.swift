// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum T: String {
    var name: String { self.rawValue }
    var nameLive: String { self.rawValue + "Live" }
    var nameTest: String { self.rawValue + "Test" }
    
    var target: Target.Dependency { .target(name: self.name) }
    var targetLive: Target.Dependency { .target(name: self.nameLive) }
    
    case AppFeature
    case HeavyBuild
    case ViewA
    case Calculator
}

extension Target.Dependency {
    static let di: Self = .product(name: "Dependencies", package: "swift-dependencies")
    static let tca: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}

let package = Package(
    name: "Internal",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: T.AppFeature.name,
            targets: [T.AppFeature.name]),
        .library(name: T.HeavyBuild.name, targets: [T.HeavyBuild.name]),
        .library(name: T.ViewA.name, targets: [T.ViewA.name]),
        .library(name: T.Calculator.name, targets: [T.Calculator.name]),
        .library(name: T.Calculator.nameLive, targets: [T.Calculator.nameLive]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
                .upToNextMajor(from: "1.0.0")),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: T.AppFeature.name,
            dependencies: [.tca, .di, T.ViewA.target]
        ),
        .target(name: T.ViewA.name, dependencies: [.tca, .di, T.Calculator.target]),
        .target(name: T.Calculator.name, dependencies: [.di]),
        .target(name: T.Calculator.nameLive, dependencies: [.di, T.HeavyBuild.target]),
        .target(name: T.HeavyBuild.name),
        .testTarget(
            name: T.HeavyBuild.nameTest,
            dependencies: [T.HeavyBuild.target]),
        .testTarget(
            name: T.ViewA.nameTest,
            dependencies: [T.ViewA.target, .tca]),
    ]
)
