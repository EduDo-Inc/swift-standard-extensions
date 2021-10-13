#if os(iOS)
import CocoaAliases

open class CustomCollectionViewCell: CocoaCollectionViewCell {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self._commonInit()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._commonInit()
  }
  
  open func _commonInit() {}
}

public final class CollectionViewCell<Content: CocoaView>: CustomCollectionViewCell {
  @available(*, deprecated, message: "Use cell.content instead")
  public override var contentView: UIView { super.contentView }
  
  public let content: Content = .init()
  
  public override func _commonInit() {
    super._commonInit()
    super.contentView.addSubview(content)
  }
  
  public override func layoutSubviews() {
    super.contentView.frame = bounds
    content.frame = bounds
  }
}
#endif
