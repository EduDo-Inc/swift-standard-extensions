#if canImport(UIKit) && !os(watchOS)
import CocoaAliases

public final class CollectionViewCell<Content: CocoaView>: CustomCollectionViewCell {
  @available(*, deprecated, message: "Use cell.content instead")
  public override var contentView: UIView { super.contentView }
  
  public let content: Content = .init()
  
  public override func _init() {
    super._init()
    super.contentView.addSubview(content)
  }
  
  public override func layoutSubviews() {
    super.contentView.frame = bounds
    content.frame = bounds
  }
}
#endif
