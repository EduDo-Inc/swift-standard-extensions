import CocoaAliases

public protocol SupplimentaryItemKindProvidingType {
  static var supplimentaryItemKind: String { get }
}

public protocol ReuseIDProvidingType {
  static var reuseID: String { get }
}

extension ReuseIDProvidingType {
  public static var reuseID: String { .init(reflecting: self) }
}

extension CocoaCollectionReusableView: ReuseIDProvidingType {}
extension CocoaCollectionViewCell: ReuseIDProvidingType {}
extension CocoaTableViewCell: ReuseIDProvidingType {}

#if os(iOS)
extension CocoaTableView {
  public func register<Cell: CocoaTableViewCell>(_ type: Cell.Type) {
    register(type, forCellReuseIdentifier: Cell.reuseID)
  }

  public func dequeueReusableCell<Cell: CocoaTableViewCell>(
    _ type: Cell.Type,
    at indexPath: IndexPath
  ) -> Cell! { dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as? Cell }
}
#endif

extension CocoaCollectionView {
  public func registerSupplimentaryItem<
    SupplimentaryItem:
      CocoaCollectionReusableView
  >(_ type: SupplimentaryItem.Type?, ofKind kind: String) {
    #if os(iOS)
    register(
      type,
      forSupplementaryViewOfKind: kind,
      withReuseIdentifier: SupplimentaryItem.reuseID
    )
    #elseif os(macOS)
    register(
      type,
      forSupplementaryViewOfKind: kind,
      withIdentifier: NSUserInterfaceItemIdentifier(rawValue: SupplimentaryItem.reuseID)
    )
    #endif
  }

  public func registerSupplimentaryItem<
    SupplimentaryItem:
      CocoaCollectionReusableView & SupplimentaryItemKindProvidingType
  >(_ type: SupplimentaryItem.Type?) {
    registerSupplimentaryItem(
      type,
      ofKind: SupplimentaryItem.supplimentaryItemKind
    )
  }
  
  public func register<Cell: CocoaCollectionViewCell>(_ type: Cell.Type?) {
    #if os(iOS)
    register(type, forCellWithReuseIdentifier: Cell.reuseID)
    #elseif os(macOS)
    register(type, forItemWithIdentifier: NSUserInterfaceItemIdentifier(Cell.reuseID))
    #endif
  }

  #if os(iOS)
  public func dequeueSupplimentaryItem<
    SupplimentaryItem: ReuseIDProvidingType
  >(_ type: SupplimentaryItem.Type, ofKind kind: String, at indexPath: IndexPath)
    -> SupplimentaryItem
  {
    dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: SupplimentaryItem.reuseID,
      for: indexPath
    ) as! SupplimentaryItem
  }

  public func dequeueSupplimentaryItem<
    SupplimentaryItem: CocoaCollectionReusableView & SupplimentaryItemKindProvidingType
  >(_ type: SupplimentaryItem.Type, at indexPath: IndexPath)
    -> SupplimentaryItem
  {
    dequeueSupplimentaryItem(
      type,
      ofKind: type.supplimentaryItemKind,
      at: indexPath
    )
  }

  public func dequeueReusableCell<Cell: CocoaCollectionViewCell>(
    _ type: Cell.Type = Cell.self,
    at indexPath: IndexPath
  ) -> Cell! { dequeueReusableCell(withReuseIdentifier: Cell.reuseID, for: indexPath) as? Cell }
  #endif
}
