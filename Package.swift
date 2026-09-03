// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-chronomorphism-derivation",
    products: [
        .library(name: "Chronomorphism Derivation", targets: ["Chronomorphism Derivation"]),
        .library(name: "Chronomorphism Derivation Core", targets: ["Chronomorphism Derivation Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-birecursive-derivation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-cofree-derivation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-free-derivation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-futumorphism-derivation.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-histomorphism-derivation.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Chronomorphism Derivation Core", dependencies: [
            .product(name: "Birecursive Derivation Core", package: "swift-birecursive-derivation"),
            .product(name: "Cofree Derivation Core", package: "swift-cofree-derivation"),
            .product(name: "Free Derivation Core", package: "swift-free-derivation"),
            .product(name: "Futumorphism Derivation Core", package: "swift-futumorphism-derivation"),
            .product(name: "Histomorphism Derivation Core", package: "swift-histomorphism-derivation"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .macro(name: "Chronomorphism Derivation Macros", dependencies: [
            "Chronomorphism Derivation Core",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),
        .target(name: "Chronomorphism Derivation", dependencies: ["Chronomorphism Derivation Macros"]),
        .testTarget(
            name: "Chronomorphism Derivation Tests",
            dependencies: ["Chronomorphism Derivation"]
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
