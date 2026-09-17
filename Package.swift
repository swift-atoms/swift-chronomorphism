// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-chronomorphism",
    products: [
        .library(name: "Chronomorphism Macro", targets: ["Chronomorphism Macro"]),
        .library(name: "Chronomorphism Macro Core", targets: ["Chronomorphism Macro Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-birecursive.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cofree.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-free.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-futumorphism.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-histomorphism.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Chronomorphism Macro Core", dependencies: [
            .product(name: "Birecursive Macro Core", package: "swift-birecursive"),
            .product(name: "Cofree Macro Core", package: "swift-cofree"),
            .product(name: "Free Macro Core", package: "swift-free"),
            .product(name: "Futumorphism Macro Core", package: "swift-futumorphism"),
            .product(name: "Histomorphism Macro Core", package: "swift-histomorphism"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .macro(name: "Chronomorphism Macro Plugin", dependencies: [
            "Chronomorphism Macro Core",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),
        .target(name: "Chronomorphism Macro", dependencies: ["Chronomorphism Macro Plugin"]),
        .testTarget(
            name: "Chronomorphism Macro Tests",
            dependencies: ["Chronomorphism Macro"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
