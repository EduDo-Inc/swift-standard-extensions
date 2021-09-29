import DeclarativeConfiguration
import CocoaAliases

#if os(iOS)
open class CustomCocoaViewController: CocoaViewController {
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
  
  open override func loadView() {
    guard !tryLoadCustomContentView() else { return }
    super.loadView()
  }
  
  open override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: animated, completion: completion)
    _onDismiss()
  }
  
  public convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self._commonInit()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._commonInit()
  }
  
  /// Only for `override` purposes, do not call directly
  open func _commonInit() {}
}
#elseif os(macOS)
open class CustomCocoaViewController: CocoaViewController {
  private(set) open var isVisible = false
  
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
  
  open override func viewWillAppear() {
    super.viewWillAppear()
    _onViewWillAppear()
  }
  
  open override func viewDidAppear() {
    isVisible = true
    super.viewDidAppear()
    _onViewDidAppear()
  }
  
  open override func viewWillDisappear() {
    super.viewWillDisappear()
    _onViewWillDisappear()
  }
  
  open override func viewDidDisappear() {
    super.viewDidDisappear()
    _onViewDidDisappear()
    isVisible = false
  }
  
  open override func viewWillLayout() {
    super.viewWillLayout()
    _onViewWillLayout()
  }
  
  open override func viewDidLayout() {
    super.viewDidLayout()
    _onViewDidLayout()
  }
  
  open override func loadView() {
    guard !tryLoadCustomContentView() else { return }
    super.loadView()
  }
  
  /// Use `override _commonInit` instead of overriding this initializer
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self._commonInit()
  }
  
  /// Use `override _commonInit` instead of overriding this initializer
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._commonInit()
  }
  /// Only for `override` purposes, do not call directly
  open func _commonInit() {}
}
#endif
