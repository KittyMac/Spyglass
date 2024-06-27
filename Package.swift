// swift-tools-version: 5.6

import PackageDescription
import Foundation

#if !os(Linux)

// For local development involving changes to libtesseract, set this to true to
// reference the locally built xcframework instead of latest github release.
// You should never commit this to the repo as true
#if false
let libtesseractTargets: [Target] = [
    .binaryTarget(
        name: "libtesseract",
        path: "libtesseract/libtesseract.xcframework.zip"
    ),
]
#else
let libtesseractTargets: [Target] = [
    .binaryTarget(
        name: "libtesseract",
        url: "https://github.com/KittyMac/Spyglass/releases/download/v0.0.11/libtesseract.xcframework.zip",
        checksum: "38efe6b860a5bdbe727db77d8d2596270fa5c871eb806926aeefc4022dda33f5"
    ),
]
#endif

let ctessTargets: [Target] = libtesseractTargets + [
    .target(
        name: "CTess",
        dependencies: [
            "libtesseract"
        ],
        cxxSettings: [
            .headerSearchPath("./")
        ],
        linkerSettings: [
            .linkedLibrary("z"),
            .linkedLibrary("c++"),
            .linkedFramework("Accelerate")
        ]
    )
]

#else

let ctessTargets: [Target] = [
    .target(
        name: "CTess",
        dependencies: [ ],
        cxxSettings: [
            .headerSearchPath("./")
        ],
        linkerSettings: [
            .linkedLibrary("z"),
            .linkedLibrary("tesseract", .when(platforms: [.linux])),
            .linkedLibrary("leptonica", .when(platforms: [.linux]))
        ]
    )
]

#endif


let package = Package(
    name: "Spyglass",
    platforms: [
        .macOS(.v10_13), .iOS(.v11)
    ],
    products: [
        .library( name: "Spyglass", targets: ["Spyglass"]),
        .library( name: "CTess", type: .dynamic, targets: ["CTess"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KittyMac/Chronometer.git", from: "0.1.0"),
        .package(url: "https://github.com/KittyMac/Hitch.git", from: "0.4.0"),
        .package(url: "https://github.com/KittyMac/Pamphlet.git", from: "0.3.62"),
        .package(url: "https://github.com/KittyMac/GzipSwift.git", from: "5.3.0"),
    ],
    targets: ctessTargets + [
        .target(
            name: "Spyglass",
            dependencies: [
                "Hitch",
                "Chronometer",
                "CTess",
                .product(name: "Gzip", package: "GzipSwift"),
            ],
            plugins: [
                .plugin(name: "PamphletReleaseOnlyPlugin", package: "Pamphlet"),
            ]
        ),
        .testTarget(
            name: "SpyglassTests",
            dependencies: ["Spyglass"]
        )
    ],
    cxxLanguageStandard: .gnucxx14
    
)


