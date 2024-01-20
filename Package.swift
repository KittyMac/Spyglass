// swift-tools-version: 5.6

import PackageDescription
import Foundation

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
        url: "https://github.com/KittyMac/Spyglass/releases/download/v0.0.7/libtesseract.xcframework.zip",
        checksum: "585f28ecf7e634602567f9c94c5a4c10a7a6ec3ccfee1af2939c55d517edb84f"
    ),
]
#endif

#if !os(Linux)
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

#endif


let package = Package(
    name: "Spyglass",
    platforms: [
        .macOS(.v10_13), .iOS(.v11)
    ],
    products: [
        .library( name: "Spyglass", targets: ["Spyglass"]),
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


