import CoreGraphics

extension CGPoint {
  public init(_ offset: CGSize) {
    self.init(x: offset.width, y: offset.height)
  }
}

