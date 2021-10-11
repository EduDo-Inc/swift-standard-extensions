import CocoaAliases
import FoundationExtensions

/// The protocol allows to track when the view is loaded using @CustomView propertyWrapper
public protocol CustomLoadableView: CocoaView {
  func didLoad(to controller: CocoaViewController)
}

/// Allows to access typed view of a viewController via corresponding property
///
/// Usage:
/// ```
/// final class ViewController: CustomCocoaViewController {
///   @CustomView
///   var contentView: ContentView
///
///   override func viewDidLoad() {
///     super.viewDidLoad()
///     contentView.label.text = "Hello, World"
///   }
/// }
///
/// extension ViewController {
///   final class ContentView: CustomCocoaView {
///     let label = UILabel { $0
///       .textAlignment(.center)
///     }
///
///     override func _commonInit() {
///       addSubview(label)
///     }
///
///     override func layoutSubviews() {
///       label.frame = bounds
///     }
///   }
/// }
/// ```
///
/// Note, that you should subclass `CustomCocoaViewController` and use `contentView` identifier for the variable
/// to enable implicit loading. Otherwise you should implement loadView method yourself.
/// ```
/// final class ViewController: CocoaViewController {
///   @CustomView
///   var contentView: ContentView
///   override func loadView() {
///     _contentView.load(to: self)
///   }
/// }
/// ```
@propertyWrapper
public struct CustomView<ContentView: CocoaView>: CustomReflectable {
  @Handler<ContentView>
  public var onViewDidLoad
  
  public var customMirror: Mirror {
    Mirror(self, children: [("loadView", { load(to: $0) })])
  }

  public init() {}

  @available(*, unavailable, message: "@CustomView can only be applied to classes")
  public var wrappedValue: ContentView {
    get { fatalError() }
    set { fatalError() }
  }

  public static subscript<Controller: CocoaViewController>(
    _enclosingInstance controller: Controller,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<Controller, ContentView>,
    storage storageKeyPath: ReferenceWritableKeyPath<Controller, Self>
  ) -> ContentView {
    get {
      guard let contentView = controller[keyPath: \.view] as? ContentView else {
        assertionFailure(
          "Call `_instance.load(contentView:to:)` in"
            + "`UIViewController.loadView` method to setup CustomView properly"
        )

        let contentView = ContentView()
        controller[keyPath: storageKeyPath].load(contentView, to: controller)
        return contentView
      }
      return contentView
    }
    set {
      controller[keyPath: storageKeyPath].load(newValue, to: controller)
    }
  }

  public func load(
    _ contentView: ContentView = .init(),
    to controller: CocoaViewController,
    onWillSet: (ContentView) -> Void = { _ in },
    onDidSet: (ContentView) -> Void = { _ in }
  ) {
    onWillSet(contentView)
    controller.view = contentView
    onDidSet(contentView)
    contentView.as(CustomLoadableView.self).map { view in
      view.didLoad(to: controller)
    }
    _onViewDidLoad(contentView)
  }
}

extension CocoaViewController {
  /// Loads `@CustomView var contentView` to the controller
  /// - Returns: `true` if loading succeed, `false` if failed
  @discardableResult
  public func tryLoadCustomContentView() -> Bool {
    let selfMirror = Mirror(reflecting: self)
    guard
      let _contentView = selfMirror.children
        .first(where: { $0.label == "_contentView" })?.value,
      let loadView = Mirror(reflecting: _contentView).children
        .first(where: { $0.label == "loadView" })?.value,
      let loadViewTo = loadView as? ((CocoaViewController) -> Void)
    else { return false }
    loadViewTo(self)
    return true
  }
}
