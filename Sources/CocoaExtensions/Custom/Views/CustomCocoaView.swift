import CocoaAliases

open class CustomCocoaView: CocoaView, CustomCocoaViewProtocol {
  /// Use `override _init` instead of overriding this initializer
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self._init()
  }

  /// Use `override _init` instead of overriding this initializer
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._init()
  }

  /// Only for `override` purposes, do not call directly
  open func _init() {}
}
