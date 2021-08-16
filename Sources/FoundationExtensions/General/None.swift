/// Codable, Equatable and Hashable Void type
public struct None: Equatable, Hashable {
  public init() {}
}

extension None: Codable {
  public init(from decoder: Decoder) throws { self.init() }
  public func encode(to encoder: Encoder) throws {}
}

extension None: ExpressibleByNilLiteral {
  public init(nilLiteral: ()) {
    self.init()
  }
}

