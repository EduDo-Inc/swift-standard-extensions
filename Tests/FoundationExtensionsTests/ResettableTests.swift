import XCTest
@testable import FoundationExtensions

func andOf(_ values: Bool...) -> Bool {
  values.reduce(true) { $0 && $1 }
}

final class ResettableTests: XCTestCase {
  struct TestStruct: Equatable {
    struct Inner: Equatable {
      var value: Int = 0
    }
    var inner: Inner = .init()
    var boolean: Bool = false
    var int: Int = 0
    var optional: Optional<Inner> = nil
  }
  
  class TestClass: Equatable {
    static func == (lhs: TestClass, rhs: TestClass) -> Bool {
      andOf(
        lhs.inner == rhs.inner,
        lhs.boolean == rhs.boolean,
        lhs.int == rhs.int,
        lhs.optional == rhs.optional
      )
    }
    
    struct Inner: Equatable {
      var value: Int = 0
    }
    
    init() {}
    
    var inner: Inner = .init()
    var boolean: Bool = false
    var int: Int = 0
    var optional: Optional<Inner> = nil
  }
  
  public func testUndoRedoValueType() {
    var value = TestStruct()
    let resettable = Resettable(value)
    
    resettable.inner.value(1)
    value.inner.value = 1
    
    resettable.boolean(true)
    value.boolean = true
    
    resettable.inner.value(2)
    value.inner.value = 2
    
    resettable.int(10)
    value.int = 10
    
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.int = 0
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.inner.value = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.boolean = false
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.inner.value = 0
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.redo()
    value.inner.value = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.int { $0 += 1 }
    value.int = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.int = 0
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.redo()
    value.int = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.redo()
    value.int = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.optional(.init())
    value.optional = .init()
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.optional.value(1)
    value.optional?.value = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.optional(nil)
    value.optional = nil
    XCTAssertEqual(resettable.wrappedValue, value)
  }
  
  public func testUndoRedoReferenceType() {
    let value = TestClass()
    let resettable = Resettable(value)
    
    resettable.inner.value(1)
    value.inner.value = 1
    
    resettable.boolean(true)
    value.boolean = true
    
    resettable.inner.value(2)
    value.inner.value = 2
    
    resettable.int(10)
    value.int = 10
    
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.int = 0
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.inner.value = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.boolean = false
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.inner.value = 0
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.redo()
    value.inner.value = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.int { $0 += 1 }
    value.int = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.undo()
    value.int = 0
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.redo()
    value.int = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.redo()
    value.int = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.optional(.init())
    value.optional = .init()
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.optional.value(1)
    value.optional?.value = 1
    XCTAssertEqual(resettable.wrappedValue, value)
    
    resettable.optional(nil)
    value.optional = nil
    XCTAssertEqual(resettable.wrappedValue, value)
  }
  
  func testCollection() {
    struct Object: Equatable {
      let id: UUID = .init()
      var value: Int = 0
    }
    
    var array = [Object(), Object()]
    let resettable = Resettable(array)
    resettable.collection.swapAt(0, 1)
    
    resettable.collection[safe: 0].value(1)
    
    array.swapAt(0, 1)
    array[0].value = 1
    XCTAssertEqual(resettable.wrappedValue, array)
    
    resettable.undo()
    array[0].value = 0
    XCTAssertEqual(resettable.wrappedValue, array)
    
    resettable.undo()
    array.swapAt(1, 0)
    XCTAssertEqual(resettable.wrappedValue, array)
    
    resettable.redo()
    array.swapAt(0, 1)
    XCTAssertEqual(resettable.wrappedValue, array)
    
    resettable.collection[safe: 0].value(2)
    resettable.redo()
    resettable.redo()
    array[0].value = 2
    XCTAssertEqual(resettable.wrappedValue, array)
  }
}
