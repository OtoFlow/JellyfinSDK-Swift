// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "JellyfinAPI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [.library(name: "JellyfinAPI", targets: ["JellyfinAPI"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.0.2"),
    ],
    targets: [
        .target(
            name: "JellyfinAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
            ],
            exclude: [
                "openapi.json",
                "openapi-generator-config.yaml",
            ]
        ),
    ]
)
