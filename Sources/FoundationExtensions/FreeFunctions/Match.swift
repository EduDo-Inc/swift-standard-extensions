@inlinable
public func match<Pattern, Value>(
  _ pattern: Pattern,
  matcher: (Pattern) -> Value
) -> Value {
  return matcher(pattern)
}
