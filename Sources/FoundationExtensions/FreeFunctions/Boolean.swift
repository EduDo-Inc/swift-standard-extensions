@inlinable
public func and(
  _ values: Bool...
) -> Bool {
  return values.allSatisfy { $0 }
}
