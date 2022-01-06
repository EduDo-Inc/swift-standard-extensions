#if os(iOS)
import FunctionalClosures

public protocol NavigationControllerDynamicOverridable {
  var overrideNavigationController: OptionalDataSource<
    Void,
    UINavigationController?
  >.Container { get set }
}
#endif
