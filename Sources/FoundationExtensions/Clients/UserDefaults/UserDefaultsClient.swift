import Foundation
import Prelude

public struct UserDefaultsClient {
  public init(
    saveValue: Operations.Save,
    loadValue: Operations.Load,
    removeValue: Operations.Remove
  ) {
    self.saveValue = saveValue
    self.loadValue = loadValue
    self.removeValue = removeValue
  }

  public var saveValue: Operations.Save
  public var loadValue: Operations.Load
  public var removeValue: Operations.Remove
}

extension UserDefaultsClient {
  public static let standard: UserDefaultsClient = .live(for: .standard)
  
  public static func live(for userDefaults: UserDefaults) -> UserDefaultsClient {
    UserDefaultsClient(
      saveValue: .init { key, value in
        userDefaults.setValue(value.dataRepresentation, forKey: key.rawValue)
      },
      loadValue: .init { key in
        userDefaults.object(forKey: key.rawValue).as(Data.self)
      },
      removeValue: .init { key in
        userDefaults.removeObject(forKey: key.rawValue)
      }
    )
  }
}

extension UserDefaultsClient {
  public enum Operations {}

  public struct Key: RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    public var rawValue: String

    public init(rawValue: String) {
      self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
      self.init(rawValue: value)
    }

    public static func bundle(_ key: Key) -> Key {
      return .bundle(.main, key)
    }

    public static func bundle(_ bundle: Bundle, _ key: Key) -> Key {
      return .init(rawValue: bundle.makeKey(key.rawValue))
    }
  }
}

extension UserDefaultsClient.Operations {
  public struct Save: Function {
    public typealias A = (UserDefaultsClient.Key, DataRepresentable)
    public typealias B = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }

    public var call: Signature
    
    public func callAsFunction(
      _ value: DataRepresentable,
      forKey key: UserDefaultsClient.Key
    ) { return call((key, value)) }
  }

  public struct Load: Function {
    public typealias A = (UserDefaultsClient.Key)
    public typealias B = Data?
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }
    
    public var call: Signature
    
    public func callAsFunction<Value: DataRepresentable>(
      of type: Value.Type = Value.self,
      forKey key: UserDefaultsClient.Key
    ) -> Value? {
      return call((key))
        .flatMap(Value.init(dataRepresentation:))
    }
  }

  public struct Remove: Function {
    public typealias A = (UserDefaultsClient.Key)
    public typealias B = Void
    
    public init(_ call: @escaping Signature) {
      self.call = call
    }

    public var call: Signature
    
    public func callAsFunction(forKey key: UserDefaultsClient.Key) {
      return call((key))
    }
  }
}
