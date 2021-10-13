#if os(iOS)
import SwiftUI
import UIKit

public class UIHostingView<RootView: View>: CustomCocoaView {
  public let controller: UIHostingController<RootView>
  
  public convenience init(@ViewBuilder content: () -> RootView) {
    self.init(rootView: content())
  }
  
  public init(rootView: RootView) {
    self.controller = .init(rootView: rootView)
    super.init(frame: .zero)
  }
  
  public override init(frame: CGRect) {
    guard let rootView = Self.tryInitOptionalRootView()
    else { fatalError("Root view is not expressible by nil literal") }
    self.controller = UIHostingController(rootView: rootView)
    super.init(frame: frame)
  }
  
  public required init?(coder: NSCoder) {
    guard let rootView = Self.tryInitOptionalRootView()
    else { fatalError("Root view is not expressible by nil literal") }
    self.controller = UIHostingController(rootView: rootView)
    super.init(coder: coder)
  }
  
  public var rootView: RootView {
    get { controller.rootView }
    set { controller.rootView = newValue }
  }
  
  public override func _commonInit() {
    super._commonInit()
    self.backgroundColor = .clear
    self.controller.view.backgroundColor = .clear
    self.addSubview(controller.view)
  }
  
  public override func layoutSubviews() {
    controller.view.frame = bounds
    controller.view.setNeedsLayout()
  }
}

extension UIHostingView {
  fileprivate static func tryInitOptionalRootView() -> RootView? {
    guard
      let rootViewType = RootView.self as? ExpressibleByNilLiteral.Type,
      let rootView = rootViewType.init(nilLiteral: ()) as? RootView
    else { return nil }
    return rootView
  }
}
#elseif os(macOS)
import SwiftUI
import AppKit

public class NSHostingController<RootView: View>: CustomCocoaViewController {
  @CustomView
  public var contentView: NSHostingView<RootView>
  private var _rootView: RootView
   
  public init(rootView: RootView) {
    self._rootView = rootView
    super.init(nibName: nil, bundle: nil)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    guard let rootView = Self.tryInitOptionalRootView()
    else { fatalError("Root view is not expressible by nil literal") }
    self._rootView = rootView
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public required init?(coder: NSCoder) {
    guard let rootView = Self.tryInitOptionalRootView()
    else { fatalError("Root view is not expressible by nil literal") }
    self._rootView = rootView
    super.init(coder: coder)
  }
  
  public override func loadView() {
    _contentView.load(NSHostingView(rootView: _rootView), to: self)
  }
}

extension NSHostingController {
  fileprivate static func tryInitOptionalRootView() -> RootView? {
    guard
      let rootViewType = RootView.self as? ExpressibleByNilLiteral.Type,
      let rootView = rootViewType.init(nilLiteral: ()) as? RootView
    else { return nil }
    return rootView
  }
}
#endif
