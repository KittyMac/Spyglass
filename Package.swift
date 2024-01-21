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
        url: "https://github.com/KittyMac/Spyglass/releases/download/v0.0.9/libtesseract.xcframework.zip",
        checksum: "b60a5c86110dfb683b44df3f29bcd7fede7787afb2064c6d3f90f220758892df"
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
        .package(url: "https://github.com/KittyMac/Hitch.git", from: "0.4.0")
    ],
    targets: ctessTargets + [
        .target(
            name: "Spyglass",
            dependencies: [
                "Hitch",
                "Chronometer",
                "CTess"
            ]
        ),
        .testTarget(
            name: "SpyglassTests",
            dependencies: ["Spyglass"]
        )
    ],
    cxxLanguageStandard: .gnucxx14
    
)


