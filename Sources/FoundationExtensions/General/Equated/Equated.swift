//
//  File.swift
//
//
//  Created by Maxim Krouk on 11/29/20.
//

import Foundation
import Prelude

@propertyWrapper
public struct Equated<Value>: Equatable {
  public init<T>(compare comparator: Comparator) where Value == T? {
    self.init(.none, compare: comparator)
  }
  
  public init(_ wrappedValue: Value, compare comparator: Comparator) {
    self.init(wrappedValue: wrappedValue, compare: comparator)
  }

  public init(wrappedValue: Value, compare comparator: Comparator) {
    self.wrappedValue = wrappedValue
    self.comparator = comparator
  }

  public var wrappedValue: Value
  public var comparator: Comparator

  public static func == (lhs: Equated<Value>, rhs: Equated<Value>) -> Bool {
    lhs.comparator.compare(lhs.wrappedValue, rhs.wrappedValue)
      && rhs.comparator.compare(rhs.wrappedValue, lhs.wrappedValue)
  }
}

extension Equated where Value: Equatable {
  public init<T>() where Value == T? {
    self.init(wrappedValue: .none)
  }
  
  public init(wrappedValue: Value) {
    self.init(wrappedValue: wrappedValue, compare: .custom(==))
  }
}

extension Equated: Error where Value: Error {
  public init(_ wrappedValue: Value) {
    self.init(wrappedValue: wrappedValue)
  }
  
  public init(wrappedValue: Value) {
    self.init(
      wrappedValue: wrappedValue,
      compare: .localizedDescription
    )
  }
  
  public var localizedDescription: String { wrappedValue.localizedDescription }
}

extension Equated: Hashable where Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    wrappedValue.hash(into: &hasher)
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Equated: Identifiable where Value: Identifiable {
  public var id: Value.ID { wrappedValue.id }
}
