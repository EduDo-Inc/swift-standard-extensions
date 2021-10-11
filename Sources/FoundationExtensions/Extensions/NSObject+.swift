import Foundation

extension NSObject {
  @inlinable
  @discardableResult
  public func setAssociatedObject<Object>(
    _ object: Object,
    forKey key: StaticString,
    policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
  ) -> Bool {
    key.withUTF8Buffer { pointer in
      if let p = pointer.baseAddress.map(UnsafeRawPointer.init) {
        objc_setAssociatedObject(self, p, object, policy)
        return true
      } else {
        return false
      }
    }
  }
  
  @inlinable
  public func getAssociatedObject<Object>(
    of type: Object.Type = Object.self,
    forKey key: StaticString
  ) -> Object? {
    key.withUTF8Buffer { pointer in
      if let p = pointer.baseAddress.map(UnsafeRawPointer.init) {
        return objc_getAssociatedObject(self, p) as? Object
      } else {
        return nil
      }
    }
  }
}
