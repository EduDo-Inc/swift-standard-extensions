#if canImport(UIKit) && !os(watchOS)
import CocoaAliases

open class CustomCollectionReusableView: CocoaCollectionReusableView, CustomCocoaViewProtocol {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self._init()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._init()
  }
  
  open func _init() {}
}
#endif
