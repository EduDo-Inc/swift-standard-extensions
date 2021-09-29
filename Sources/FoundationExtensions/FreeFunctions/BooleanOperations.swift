@inlinable
public func and(
  _ values: Bool...
) -> Bool {
  return values.allSatisfy { $0 }
}

@inlinable
public func or(
  _ values: Bool...
) -> Bool {
  return values.contains { $0 }
}
