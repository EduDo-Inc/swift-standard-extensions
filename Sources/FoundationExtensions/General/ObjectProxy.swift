// https://www.swiftbysundell.com/articles/accessing-a-swift-property-wrappers-enclosing-instance/

import DeclarativeConfiguration
import Foundation

@propertyWrapper
public struct ObjectProxy<EnclosingType: AnyObject, Value> {
  public typealias ValueFPath = FunctionalKeyPath<EnclosingType, Value>
  public typealias ValueKeyPath = ReferenceWritableKeyPath<EnclosingType, Value>
  public typealias StorageKeyPath = ReferenceWritableKeyPath<EnclosingType, Self>

  public static subscript(
    _enclosingInstance instance: EnclosingType,
    wrapped wrappedKeyPath: ValueKeyPath,
    storage storageKeyPath: StorageKeyPath
  ) -> Value {
    get {
      let lens = instance[keyPath: storageKeyPath].lens
      return lens.extract(from: instance)
    }
    set {
      let wrapper = instance[keyPath: storageKeyPath]
      _ = wrapper.lens.embed(newValue, in: instance)
      wrapper._onDidSet(newValue)
    }
  }

  @available(*, unavailable, message: "@Proxy can only be applied to classes")
  public var wrappedValue: Value {
    get { fatalError() }
    set { fatalError() }
  }

  private let lens: ValueFPath

  @Handler<Value>
  public var onDidSet

  public init(_ lens: ValueFPath) {
    self.lens = lens
  }

  public init(_ keyPath: ValueKeyPath) {
    self.lens = .init(keyPath)
  }
}
