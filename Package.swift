// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-chronomorphism",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Chronomorphism Macro", targets: ["Chronomorphism Macro"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-recursive.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-functor.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-corecursive.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-birecursive.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cofree.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-free.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-futumorphism.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-histomorphism.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Chronomorphism Macro Core", dependencies: [
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
            dependencies: [
                .product(name: "Recursive Macro", package: "swift-recursive"),
                .product(name: "Histomorphism Macro", package: "swift-histomorphism"),
                .product(name: "Futumorphism Macro", package: "swift-futumorphism"),
                .product(name: "Functor Base Macro", package: "swift-functor"),
                .product(name: "Free Macro", package: "swift-free"),
                .product(name: "Corecursive Macro", package: "swift-corecursive"),
                .product(name: "Cofree Macro", package: "swift-cofree"),"Chronomorphism Macro"]
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

// Consumer compilation must reject visibility regressions, even when other packages suppress warnings.
for target in package.targets where target.type == .test || target.name.hasSuffix("Consumer Fixtures") {
    target.swiftSettings = (target.swiftSettings ?? []) + [.treatAllWarnings(as: .error)]
}
