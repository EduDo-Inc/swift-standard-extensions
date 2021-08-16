import Foundation

public protocol DataRepresentable {
  var dataRepresentation: Data { get }
  init?(dataRepresentation: Data)
}

extension Data: DataRepresentable {
  public var dataRepresentation: Data { self }
  public init(dataRepresentation data: Data) {
    self = data
  }
}

extension String: DataRepresentable {
  public var dataRepresentation: Data { data(using: .utf8)! }

  public init?(dataRepresentation data: Data) {
    self.init(data: data, encoding: .utf8)
  }
}

extension Bool: DataRepresentable {
  public var dataRepresentation: Data {
    var value = self
    return Data(bytes: &value, count: MemoryLayout<Self>.size)
  }

  public init?(dataRepresentation data: Data) {
    let size = MemoryLayout<Self>.size
    guard data.count == size else { return nil }
    var value: Bool = false
    let actualSize = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0) })
    assert(actualSize == MemoryLayout.size(ofValue: value))
    self = value
  }
}

extension Numeric {
  public var dataRepresentation: Data {
    var value = self
    return Data(bytes: &value, count: MemoryLayout<Self>.size)
  }

  public init?(dataRepresentation data: Data) {
    let size = MemoryLayout<Self>.size
    guard data.count == size else { return nil }
    var value: Self = .zero
    let actualSize = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0) })
    assert(actualSize == MemoryLayout.size(ofValue: value))
    self = value
  }
}

extension Int: DataRepresentable {}
extension Double: DataRepresentable {}
extension Float: DataRepresentable {}
