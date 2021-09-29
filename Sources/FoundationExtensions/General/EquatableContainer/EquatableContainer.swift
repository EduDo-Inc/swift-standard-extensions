//
//  File.swift
//
//
//  Created by Maxim Krouk on 11/29/20.
//

import Foundation

@propertyWrapper
public struct EquatableContainer<Value>: Equatable {
  public init<T>(compare comparator: Comparator<Value>) where Value == T? {
    self.init(.none, compare: comparator)
  }
  
  public init(_ wrappedValue: Value, compare comparator: Comparator<Value>) {
    self.init(wrappedValue: wrappedValue, compare: comparator)
  }

  public init(wrappedValue: Value, compare comparator: Comparator<Value>) {
    self.wrappedValue = wrappedValue
    self.comparator = comparator
  }

  public var wrappedValue: Value
  public var comparator: Comparator<Value>

  public static func == (lhs: EquatableContainer<Value>, rhs: EquatableContainer<Value>) -> Bool {
    and(
      lhs.comparator.compare(lhs.wrappedValue, rhs.wrappedValue),
      rhs.comparator.compare(rhs.wrappedValue, lhs.wrappedValue)
    )
  }
}

extension EquatableContainer where Value: Equatable {
  public init<T>() where Value == T? {
    self.init(wrappedValue: .none)
  }
  
  public init(wrappedValue: Value) {
    self.init(wrappedValue: wrappedValue, compare: .custom(==))
  }
}

extension EquatableContainer: Error where Value: Error {
  public init(_ wrappedValue: Value) {
    self.init(wrappedValue: wrappedValue)
  }
  
  public init(wrappedValue: Value) {
    self.init(
      wrappedValue: wrappedValue,
      compare: .property(\.localizedDescription)
    )
  }
  
  public var localizedDescription: String { wrappedValue.localizedDescription }
}

extension EquatableContainer: Hashable where Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    wrappedValue.hash(into: &hasher)
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension EquatableContainer: Identifiable where Value: Identifiable {
  public var id: Value.ID { wrappedValue.id }
}
