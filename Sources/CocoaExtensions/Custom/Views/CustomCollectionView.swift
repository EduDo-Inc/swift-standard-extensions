#if canImport(UIKit) && !os(watchOS)
import CocoaAliases

open class CustomCocoaCollectionView: CocoaCollectionView, CustomCocoaViewProtocol {
  public override init(
    frame: CGRect,
    collectionViewLayout layout: CocoaCollectionViewLayout
  ) {
    super.init(frame: frame, collectionViewLayout: layout)
    self._init()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._init()
  }
  
  open func _init() {}
}
#endif
