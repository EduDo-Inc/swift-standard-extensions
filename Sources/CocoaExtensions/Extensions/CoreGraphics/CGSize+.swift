import CoreGraphics

extension CGSize {
  public init(_ point: CGPoint) {
    self.init(width: point.x, height: point.y)
  }

  public static func square(_ length: CGFloat) -> CGSize {
    self.init(width: length, height: length)
  }
  
  public var center: CGPoint {
    CGPoint(x: width / 2, y: height / 2)
  }
}
