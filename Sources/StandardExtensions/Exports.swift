#if canImport(SwiftUI) && canImport(SwiftUIExtensions)
@_exported import SwiftUIExtensions
#elseif canImport(UIKit) || canImport(AppKit)
@_exported import CocoaExtensions
#elseif canImport(Foundation)
@_exported import FoundationExtensions
#endif
