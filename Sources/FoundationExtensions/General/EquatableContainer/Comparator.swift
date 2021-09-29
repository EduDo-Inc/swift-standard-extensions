public struct Comparator<Value> {
  public let compare: (Value, Value) -> Bool
}

extension Comparator where Value: Equatable {
  public static var `default`: Comparator { .custom(==) }
}

extension Comparator {
  public static func custom(_ compare: @escaping (Value, Value) -> Bool) -> Self {
    return .init(compare: compare)
  }
  
  public static func property<Property: Equatable>(
    _ scope: @escaping (Value) -> Property
  ) -> Self {
    return .init { scope($0) == scope($1) }
  }
  
  public static func property<Wrapped, Property: Equatable>(
    _ scope: @escaping (Wrapped) -> Property
  ) -> Self where Value == Optional<Wrapped> {
    return .init { $0.map(scope) == $1.map(scope) }
  }
  
  public static var dump: Self {
    .init { lhs, rhs in
      var (lhsDump, rhsDump) = ("", "")
      Swift.dump(lhs, to: &lhsDump)
      Swift.dump(rhs, to: &rhsDump)
      return lhsDump == rhsDump
    }
  }
}
