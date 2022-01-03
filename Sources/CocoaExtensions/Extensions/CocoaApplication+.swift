#if !os(watchOS)
import CocoaAliases

extension CocoaApplication {
  public var firstKeyWindow: CocoaWindow? {
      windows.first(where: { $0.isKeyWindow })
  }
}
#endif
