#if canImport(UIKit) && !os(watchOS)
import UIKit

open class CustomNavigationController: UINavigationController, CustomCocoaViewControllerProtocol {
  private(set) open var isVisible = false
  
  @Handler<Void>
  public var onDismiss
  
  @Handler<Void>
  public var onViewDidLoad
  
  @Handler<Void>
  public var onViewWillAppear
  
  @Handler<Void>
  public var onViewDidAppear
  
  @Handler<Void>
  public var onViewWillDisappear
  
  @Handler<Void>
  public var onViewDidDisappear
  
  @Handler<Void>
  public var onViewWillLayout
  
  @Handler<Void>
  public var onViewDidLayout
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    _onViewDidLoad()
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _onViewWillAppear()
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    isVisible = true
    super.viewDidAppear(animated)
    _onViewDidAppear()
  }
  
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    _onViewWillDisappear()
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    _onViewDidDisappear()
    isVisible = false
  }
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    _onViewWillLayout()
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    _onViewDidLayout()
  }
  
  open override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: animated, completion: completion)
    _onDismiss()
  }
  
  public override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    self._init()
  }
  
  public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
    super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    self._init()
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self._init()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._init()
  }
  
  /// Only for `override` purposes, do not call directly
  open func _init() {}
}
#endif
