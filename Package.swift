// swift-tools-version: 5.6

import PackageDescription
import Foundation
/*
#if canImport(JavaScriptCore)
let spyglassTargets: [Target] = [
    .target(
        name: "Spyglass",
        dependencies: [
            "Hitch",
            "Chronometer"
        ]
    )
]
#else

var jscLibrary = "javascriptcoregtk-4.0"
if FileManager.default.fileExists(atPath: "/usr/include/webkitgtk-4.1") {
    jscLibrary = "javascriptcoregtk-4.1"
}

let spyglassTargets: [Target] = [
    .target(
        name: "CJSCore",
        linkerSettings: [
            .linkedLibrary(jscLibrary, .when(platforms: [.linux]))
        ]
    ),
    .target(
        name: "Spyglass",
        dependencies: [
            "CJSCore",
            "Hitch",
            "Chronometer"
        ]
    ),
]
#endif
*/
let package = Package(
    name: "Spyglass",
    platforms: [
        .macOS(.v10_13), .iOS(.v11)
    ],
    products: [
        .library( name: "Spyglass", targets: ["Spyglass"]),
        .library( name: "libtesseract", targets: ["libtesseract"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KittyMac/Chronometer.git", from: "0.1.0"),
        .package(url: "https://github.com/KittyMac/Hitch.git", from: "0.4.0")
    ],
    targets: [
        .binaryTarget(
            name: "libtesseract",
            url: "https://github.com/KittyMac/Spyglass/releases/download/v0.0.1/libtesseract.xcframework.zip",
            checksum: "2bb88d3a5d5c1b6aeaa729b99ad375957d933c1eac14f1190931081650320ac5"
        ),
        .target(
            name: "Spyglass",
            dependencies: [
                "Hitch",
                "Chronometer"
            ]
        ),
        .testTarget(
            name: "SpyglassTests",
            dependencies: ["Spyglass"]
        )
    ]
)
