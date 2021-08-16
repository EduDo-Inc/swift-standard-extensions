import CocoaAliases

open class CustomCocoaView: CocoaView {
  /// Use `override _commonInit` instead of overriding this initializer
  public override init(frame: CGRect) {
    super.init(frame: frame)
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
