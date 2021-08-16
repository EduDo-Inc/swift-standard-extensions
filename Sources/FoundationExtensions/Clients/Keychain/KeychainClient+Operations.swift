import Foundation
import Prelude

extension KeychainClient {
  public enum Operations {
    public struct Save: Function {
      public typealias A = (String, DataRepresentable, AccessPolicy)
      public typealias B = Void
      
      public init(_ call: @escaping Signature) {
        self.call = call
      }
      
      public var call: Signature
      
      public func callAsFunction(
        _ value: DataRepresentable,
        forKey key: String,
        policy: AccessPolicy = .default
      ) { return call((key, value, policy)) }

      public enum AccessPolicy {
        public static var `default`: AccessPolicy { .accessibleWhenUnlocked }
        case accessibleWhenUnlocked
        case accessibleWhenUnlockedThisDeviceOnly
        case accessibleAfterFirstUnlock
        case accessibleAfterFirstUnlockThisDeviceOnly
        case accessibleWhenPasscodeSetThisDeviceOnly
        
        @available(
          iOS,
          introduced: 4.0,
          deprecated: 12.0,
          message:
            "Use an accessibility level that provides some user protection, such as .accessibleAfterFirstUnlock"
        )
        case accessibleAlways
        
        @available(
          iOS,
          introduced: 4.0,
          deprecated: 12.0,
          message:
            "Use an accessibility level that provides some user protection, such as .accessibleAfterFirstUnlockThisDeviceOnly"
        )
        case accessibleAlwaysThisDeviceOnly
      }
    }

    public struct Load: Function {
      public typealias A = String
      public typealias B = Data?
      
      public init(_ call: @escaping Signature) {
        self.call = call
      }

      public var call: Signature

      public func callAsFunction<Value: DataRepresentable>(
        of type: Value.Type = Value.self,
        forKey key: String
      ) -> Value? {
        return call(key)
          .flatMap(Value.init(dataRepresentation:))
      }
    }

    public struct Remove: Function {
      public typealias A = String
      public typealias B = Void
      
      public init(_ call: @escaping Signature) {
        self.call = call
      }
      
      public var call: Signature
      public func callAsFunction(forKey key: String) {
        return call(key)
      }
    }
  }
}

#if canImport(Security)
extension Keychain.AccessPolicy {
  init(_ operationPolicy: KeychainClient.Operations.Save.AccessPolicy) {
    switch operationPolicy {
    case .accessibleWhenUnlocked:
      self = .accessibleWhenUnlocked
    case .accessibleWhenUnlockedThisDeviceOnly:
      self = .accessibleWhenUnlockedThisDeviceOnly
    case .accessibleAfterFirstUnlock:
      self = .accessibleAfterFirstUnlock
    case .accessibleAfterFirstUnlockThisDeviceOnly:
      self = .accessibleAfterFirstUnlockThisDeviceOnly
    case .accessibleWhenPasscodeSetThisDeviceOnly:
      self = .accessibleWhenPasscodeSetThisDeviceOnly
    case .accessibleAlways:
      self = .accessibleAlways
    case .accessibleAlwaysThisDeviceOnly:
      self = .accessibleAlwaysThisDeviceOnly
    }
  }
}
#endif
