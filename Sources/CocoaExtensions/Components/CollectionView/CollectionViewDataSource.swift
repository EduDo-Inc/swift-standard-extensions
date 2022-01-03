#if canImport(UIKit) && !os(watchOS)
import CocoaAliases

public class CollectionViewDataSource<
  CellView: CocoaView,
  SupplimentaryView: CocoaView
>: NSObject, CocoaCollectionViewDataSource {
  @DataSource<Void, Int>
  public var numberOfSections = .init { 0 }
  
  @DataSource<Int, Int>
  public var numberOfItemsInSection = .init { _ in 0 }
  
  @Handler2<CollectionViewCell<CellView>, IndexPath>
  public var reconfigureCell
  
  @Handler3<CollectionReusableView<SupplimentaryView>, String, IndexPath>
  public var reconfigureSupplimentaryView
  
  public func collectionView(
    _ collectionView: CocoaCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return $numberOfItemsInSection(section)
  }
  
  public func numberOfSections(in collectionView: CocoaCollectionView) -> Int {
    return _numberOfSections()
  }
  
  public func collectionView(
    _ collectionView: CocoaCollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> CocoaCollectionViewCell {
    let cell = collectionView
      .dequeueReusableCell(CollectionViewCell<CellView>.self, at: indexPath)
      .or(CollectionViewCell<CellView>())
    _reconfigureCell(cell, indexPath)
    return cell
  }
  
  public func collectionView(
    _ collectionView: CocoaCollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> CocoaCollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: CollectionReusableView<SupplimentaryView>.reuseID,
      for: indexPath
    )
    .as(CollectionReusableView<SupplimentaryView>.self)
    .or(CollectionReusableView<SupplimentaryView>())
    _reconfigureSupplimentaryView(view, kind, indexPath)
    return view
  }
}
#endif
