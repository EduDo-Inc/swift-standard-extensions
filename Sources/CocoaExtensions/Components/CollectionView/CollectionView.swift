#if os(iOS)
import CocoaAliases
import Prelude

open class CustomCocoaCollectionView: CocoaCollectionView {
  public override init(frame: CGRect, collectionViewLayout layout: CocoaCollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    self._commonInit()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._commonInit()
  }
  
  open func _commonInit() {}
}

public final class CollectionView<
  CellView: CocoaView,
  SupplimentaryView: CocoaView
>: CustomCocoaCollectionView {
  @available(*, deprecated, message: "Use `.customDataSource` instead")
  public override var dataSource: CocoaCollectionViewDataSource? {
    get { super.dataSource }
    set { super.dataSource = newValue }
  }
  
  public let customDataSource = CollectionViewDataSource<CellView, SupplimentaryView>()
  
  @available(*, deprecated, message: "Use `.customPrefetchDataSource` instead")
  public override var prefetchDataSource: CocoaCollectionViewPrefetching? {
    get { super.prefetchDataSource }
    set { super.prefetchDataSource = newValue }
  }
  
  public let customPrefetchDataSource = PrefetchingDataSource()
  
  @available(*, deprecated, message: "Use `.publishers.<delegate_publisher>` instead")
  public override var delegate: CocoaCollectionViewDelegate? {
    get { super.delegate }
    set { super.delegate = newValue }
  }
  
  public override func _commonInit() {
    super._commonInit()
    super.dataSource = customDataSource
    super.prefetchDataSource = customPrefetchDataSource
    self.registerReusableItemTypes()
  }
  
  private func registerReusableItemTypes() {
    register(CollectionViewCell<CellView>.self)
    
    registerSupplimentaryItem(
      CollectionReusableView<SupplimentaryView>.self,
      ofKind: CocoaCollectionView.elementKindSectionHeader
    )
    
    registerSupplimentaryItem(
      CollectionReusableView<SupplimentaryView>.self,
      ofKind: CocoaCollectionView.elementKindSectionFooter
    )
  }
  
  public func dequeueReusableCellView(
    for indexPath: IndexPath
  ) -> CellView {
    return dequeueReusableCell(
      CollectionViewCell<CellView>.self,
      at: indexPath
    ).content
  }
  
  public func cellViewForItem(at indexPath: IndexPath) -> CellView? {
    return cellForItem(at: indexPath)
      .as(CollectionViewCell<CellView>.self)
      .map(\.content)
  }
  
  public func dequeueSupplimentaryItemView(
    ofKind kind: String,
    at indexPath: IndexPath
  ) -> SupplimentaryView {
    dequeueSupplimentaryItem(
      CollectionReusableView<SupplimentaryView>.self,
      ofKind: kind,
      at: indexPath
    ).content
  }
  
  public func supplementaryItemView(
    forElementKind kind: String,
    at indexPath: IndexPath
  ) -> SupplimentaryView? {
    self.supplementaryView(forElementKind: kind, at: indexPath)
      .as(CollectionReusableView<SupplimentaryView>.self)
      .map(\.content)
  }
}

#endif
