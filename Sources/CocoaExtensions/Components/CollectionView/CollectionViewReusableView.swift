#if os(iOS)
import CocoaAliases

open class CustomCollectionReusableView: CocoaCollectionReusableView {
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

public class CollectionReusableView<Content: CocoaView>: CustomCollectionReusableView {
  public let content: Content = .init()
  
  public override func _commonInit() {
    super._commonInit()
    self.addSubview(content)
  }
  
  public override func layoutSubviews() {
    content.frame = bounds
  }
}

#endif
