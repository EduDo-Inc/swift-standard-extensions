import Combine
import CocoaAliases

public class PrefetchingDataSource: NSObject {
  public override init() {}

  private let prefetchRequestSubject = PassthroughSubject<[IndexPath], Never>()
  public var prefetchRequestPublisher: AnyPublisher<[IndexPath], Never> {
    return prefetchRequestSubject.eraseToAnyPublisher()
  }
  
  private let cancelPrefetchRequestSubject = PassthroughSubject<[IndexPath], Never>()
  public var cancelPrefetchRequestPublisher: AnyPublisher<[IndexPath], Never> {
    return cancelPrefetchRequestSubject.eraseToAnyPublisher()
  }
}

#if os(iOS)
extension PrefetchingDataSource:
  UICollectionViewDataSourcePrefetching,
  UITableViewDataSourcePrefetching
{
  public func tableView(
    _ tableView: UITableView,
    prefetchRowsAt indexPaths: [IndexPath]
  ) {
    cancelPrefetchRequestSubject.send(indexPaths)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    prefetchItemsAt indexPaths: [IndexPath]
  ) {
    cancelPrefetchRequestSubject.send(indexPaths)
  }

  public func tableView(
    _ tableView: UITableView,
    cancelPrefetchingForRowsAt indexPaths: [IndexPath]
  ) {
    cancelPrefetchRequestSubject.send(indexPaths)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cancelPrefetchingForItemsAt indexPaths: [IndexPath]
  ) {
    cancelPrefetchRequestSubject.send(indexPaths)
  }
}
#elseif os(macOS)
extension PrefetchingDataSource: NSCollectionViewPrefetching {
  public func collectionView(
    _ collectionView: NSCollectionView,
    prefetchItemsAt indexPaths: [IndexPath]
  ) {
    prefetchRequestSubject.send(indexPaths)
  }
  
  public func collectionView(
    _ collectionView: NSCollectionView,
    cancelPrefetchingForItemsAt indexPaths: [IndexPath]
  ) {
    cancelPrefetchRequestSubject.send(indexPaths)
  }
}
#endif
