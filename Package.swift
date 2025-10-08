// swift-tools-version: 5.6

import PackageDescription
import Foundation

// For local development involving changes to libtesseract, set this to true to
// reference the locally built xcframework instead of latest github release.
// You should never commit this to the repo as true
#if false
let libtesseractBinaryTargets: [Target] = [
    .binaryTarget(
        name: "libtesseract",
        path: "libtesseract/libtesseract.xcframework.zip",
        condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS])
    ),
]
#else
let libtesseractBinaryTargets: [Target] = [
    .binaryTarget(
        name: "libtesseract",
        url: "https://github.com/KittyMac/Spyglass/releases/download/v0.0.11/libtesseract.xcframework.zip",
        checksum: "38efe6b860a5bdbe727db77d8d2596270fa5c871eb806926aeefc4022dda33f5"
    ),
]
#endif

let package = Package(
    name: "Spyglass",
    products: [
        .library( name: "Spyglass", targets: ["Spyglass"]),
        .library( name: "CTess", targets: ["CTess"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KittyMac/Chronometer.git", from: "0.1.0"),
        .package(url: "https://github.com/KittyMac/Hitch.git", from: "0.4.0"),
        .package(url: "https://github.com/KittyMac/GzipSwift.git", from: "5.3.0"),
    ],
    targets: libtesseractBinaryTargets + [
        .target(
            name: "CTess",
            dependencies: [
                .target(name: "libtesseract", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS]))
            ],
            cxxSettings: [
                .headerSearchPath("./")
            ],
            linkerSettings: [
                .linkedLibrary("tesseract", .when(platforms: [.linux, .android])),
                .linkedLibrary("leptonica", .when(platforms: [.linux, .android])),
                .linkedLibrary("z", .when(platforms: [.linux, .android, .macOS, .iOS, .tvOS, .watchOS])),
                .linkedLibrary("c++", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS])),
                .linkedFramework("Accelerate", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS]))
            ]
        ),
        .target(
            name: "Spyglass",
            dependencies: [
                "Hitch",
                "Chronometer",
                "CTess",
                .product(name: "Gzip", package: "GzipSwift")
            ]
        ),
        .testTarget(
            name: "SpyglassTests",
            dependencies: ["Spyglass"]
        )
    ],
    cxxLanguageStandard: .gnucxx14
    
)


