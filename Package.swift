// swift-tools-version:5.3

import PackageDescription

extension String {
  static func github(_ path: String) -> String { "https://github.com/\(path).git" }
}

let package = Package(
  name: "swift-essential-extensions",
  products: [
    .library(
      name: "EssentialExtensions",
      targets: ["EssentialExtensions"]
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
      url: .github("makeupstudio/combine-cocoa"),
      .upToNextMinor(from: "0.0.1")
    ),
    .package(
      name: "cocoa-aliases",
      url: .github("makeupstudio/cocoa-aliases"),
      .upToNextMajor(from: "1.1.1")
    ),
    .package(
      name: "swift-declarative-configuration",
      url: .github("makeupstudio/swift-declarative-configuration"),
      .upToNextMinor(from: "0.3.0")
    ),
//    .package(
//      name: "SwiftUIX",
//      url: .github("swiftuix/swiftuix"),
//      .upToNextMinor(from: "0.0.8")
//    ),
    .package(
      name: "weak",
      url: .github("makeupstudio/weak"),
      .upToNextMajor(from: "1.0.1")
    ),
    .package(
      name: "swift-prelude",
      url: .github("maximkrouk/swift-prelude"),
      .branch("main")
    )
  ],
  targets: [
    .target(
      name: "EssentialExtensions",
      dependencies: [
        .target(name: "FoundationExtensions")
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
        ),
//        .product(
//          name: "SwiftUIX",
//          package: "SwiftUIX"
//        )
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
