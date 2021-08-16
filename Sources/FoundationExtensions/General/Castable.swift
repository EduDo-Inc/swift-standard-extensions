import Foundation

public func _cast<U, T>(_ object: U, to type: T.Type) -> T? {
  object as? T
}

public protocol Castable {
  func `as`<T>(_ type: T.Type) -> T?
  func `is`<T>(_ type: T.Type) -> Bool
}

extension Castable {
  public func `as`<T>(_ type: T.Type) -> T? {
    _cast(self, to: type)
  }

  public func `is`<T>(_ type: T.Type) -> Bool {
    self is T
  }
}

extension Optional: Castable {}

extension NSObject: Castable {}
