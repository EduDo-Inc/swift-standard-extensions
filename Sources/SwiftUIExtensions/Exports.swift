#if canImport(SwiftUIX) && canImport(SwiftUI)
@_exported import SwiftUIX
#elseif canImport(SwiftUI)
@_exported import SwiftUI
#endif

#if canImport(UIKit) || canImport(AppKit)
@_exported import CocoaExtensions
#elseif canImport(Foundation)
@_exported import FoundationExtensions
#endif

