import Foundation
import Prelude

public protocol Castable {
  func `as`<T>(_ type: T.Type) -> T?
  func `is`<T>(_ type: T.Type) -> Bool
}

extension Castable {
  public func `as`<T>(_ type: T.Type) -> T? {
    cast(to: type)(self)
  }

  public func `is`<T>(_ type: T.Type) -> Bool {
    isCastable(to: type)(self)
  }
}

extension Optional: Castable {}

extension NSObject: Castable {}
