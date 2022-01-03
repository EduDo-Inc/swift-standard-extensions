#if canImport(UIKit) && !os(watchOS)
import CocoaAliases
import Prelude

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
  
  public override func _init() {
    super._init()
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
