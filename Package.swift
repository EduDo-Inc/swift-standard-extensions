// swift-tools-version:5.3

import PackageDescription

extension String {
  static func github(_ path: String) -> String {
    return "https://github.com/\(path).git"
  }
}

let package = Package(
  name: "swift-standard-extensions",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "StandardExtensions",
      targets: ["StandardExtensions"]
    ),
    .library(
      name: "CocoaExtensions",
      targets: ["CocoaExtensions"]
    ),
    .library(
      name: "FoundationExtensions",
      targets: ["FoundationExtensions"]
    ),
    .library(
      name: "SwiftUIExtensions",
      targets: ["SwiftUIExtensions"]
    )
  ],
  dependencies: [
    .package(
      name: "combine-cocoa",
      url: .github("capturecontext/combine-cocoa"),
      .upToNextMinor(from: "0.0.2")
    ),
    .package(
      name: "combine-extensions",
      url: .github("capturecontext/combine-extensions"),
      .upToNextMinor(from: "0.0.3")
    ),
    .package(
      name: "cocoa-aliases",
      url: .github("capturecontext/cocoa-aliases"),
      .upToNextMajor(from: "2.0.2")
    ),
    .package(
      name: "swift-declarative-configuration",
      url: .github("capturecontext/swift-declarative-configuration"),
      .upToNextMinor(from: "0.3.0")
    ),
    .package(
      name: "swift-capture",
      url: .github("capturecontext/swift-capture"),
      .upToNextMajor(from: "2.0.0")
    ),
    .package(
      name: "swift-prelude",
      url: .github("capturecontext/swift-prelude"),
      .branch("develop")
    ),
    .package(
      name: "swift-custom-dump",
      url: "https://github.com/pointfreeco/swift-custom-dump",
      .upToNextMajor(from: "0.3.0")
    ),
  ],
  targets: [
    .target(
      name: "StandardExtensions",
      dependencies: [
        .target(name: "SwiftUIExtensions")
      ]
    ),
    .target(
      name: "FoundationExtensions",
      dependencies: [
        .product(
          name: "DeclarativeConfiguration",
          package: "swift-declarative-configuration"
        ),
        .product(
          name: "Prelude",
          package: "swift-prelude"
        ),
        .product(
          name: "CombineExtensions",
          package: "combine-extensions"
        ),
        .product(
          name: "Capture",
          package: "swift-capture"
        ),
        .product(
          name: "CustomDump",
          package: "swift-custom-dump"
        )
      ]
    ),
    .target(
      name: "CocoaExtensions",
      dependencies: [
        .target(name: "FoundationExtensions"),
        .product(
          name: "CocoaAliases",
          package: "cocoa-aliases"
        ),
        .product(
          name: "CombineCocoa",
          package: "combine-cocoa"
        )
      ]
    ),
    .target(
      name: "SwiftUIExtensions",
      dependencies: [
        .target(name: "CocoaExtensions"),
        .product(
          name: "CocoaAliases",
          package: "cocoa-aliases"
        )
      ]
    ),
    
    // MARK: ––––––––––––– Tests –––––––––––––
    
    .testTarget(
      name: "FoundationExtensionsTests",
      dependencies: [
        .target(name: "FoundationExtensions")
      ]
    ),
  ]
)
