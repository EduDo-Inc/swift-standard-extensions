// swift-tools-version:5.3

import PackageDescription

extension String {
  static func github(_ path: String) -> String { "https://github.com/\(path).git" }
}

let package = Package(
  name: "swift-standard-extensions",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15)
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
      .upToNextMinor(from: "0.0.1")
    ),
    .package(
      name: "combine-extensions",
      url: .github("capturecontext/combine-extensions"),
      .upToNextMinor(from: "0.0.1")
    ),
    .package(
      name: "cocoa-aliases",
      url: .github("capturecontext/cocoa-aliases"),
      .branch("main")
    ),
    .package(
      name: "swift-declarative-configuration",
      url: .github("capturecontext/swift-declarative-configuration"),
      .upToNextMinor(from: "0.0.1")
    ),
    .package(
      name: "weak",
      url: .github("capturecontext/weak"),
      .upToNextMajor(from: "1.0.0")
    ),
    .package(
      name: "swift-prelude",
      url: .github("capturecontext/swift-prelude"),
      .branch("develop")
    )
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
          name: "Weak",
          package: "weak"
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
