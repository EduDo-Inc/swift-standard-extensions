import XCTest
@testable import FoundationExtensions

final class ReferenceTests: XCTestCase {
  func testReferenceObservation() {
    class Object: ReferenceProvider {
      var value = 0
    }
    
    let object = Object()
    let reference = object.reference(for: \.value)
    
    var handledOnChange: Int?
    var numberOfTrackedChanges = 0
    var numberOfTrackedSets = 0
    let trackedReference = reference.onChange {
      handledOnChange = $0
      numberOfTrackedChanges += 1
    }.onSet { _ in
      numberOfTrackedSets += 1
    }
    
    object.value = 1
    
    XCTAssertEqual(object.value, reference.wrappedValue)
    XCTAssertEqual(object.value, trackedReference.wrappedValue)
    
    // Reference does not handle direct object changes
    XCTAssertEqual(handledOnChange, nil)
    XCTAssertEqual(numberOfTrackedSets, 0)
    XCTAssertEqual(numberOfTrackedChanges, 0)
    
    trackedReference.wrappedValue = 2
    
    XCTAssertEqual(object.value, 2)
    XCTAssertEqual(object.value, reference.wrappedValue)
    XCTAssertEqual(object.value, trackedReference.wrappedValue)
    XCTAssertEqual(object.value, handledOnChange)
    XCTAssertEqual(numberOfTrackedSets, 1)
    XCTAssertEqual(numberOfTrackedChanges, 1)
    
    trackedReference.wrappedValue = 2
    
    XCTAssertEqual(object.value, 2)
    XCTAssertEqual(object.value, reference.wrappedValue)
    XCTAssertEqual(object.value, trackedReference.wrappedValue)
    XCTAssertEqual(object.value, handledOnChange)
    XCTAssertEqual(numberOfTrackedSets, 2)
    XCTAssertEqual(numberOfTrackedChanges, 1)
    
    guard
      #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    else { return }
    
    object.value = 0
    XCTAssertEqual(object.value, reference.wrappedValue)
    
    var handledOnPublish: Int?
    var numberOfPublishedChanges = 0
    var cancellable = reference.publisher.sink {
      handledOnPublish = $0
      numberOfPublishedChanges += 1
    }
    
    // The publisher emits an initial value
    XCTAssertEqual(handledOnPublish, 0)
    XCTAssertEqual(numberOfPublishedChanges, 1)
    
    object.value = 1
    
    XCTAssertEqual(object.value, reference.wrappedValue)
    
    // Reference does not handle direct object changes
    // but the publisher emits an initial value
    XCTAssertEqual(handledOnPublish, 0)
    XCTAssertEqual(numberOfPublishedChanges, 1)
    
    reference.wrappedValue = 2
    
    XCTAssertEqual(object.value, 2)
    XCTAssertEqual(object.value, reference.wrappedValue)
    XCTAssertEqual(object.value, trackedReference.wrappedValue)
    XCTAssertEqual(object.value, handledOnPublish)
    XCTAssertEqual(numberOfPublishedChanges, 2)
    
    // Tracked reference is a wrapper for the reference here
    // so these changes should publish events too
    trackedReference.wrappedValue = 2
    
    XCTAssertEqual(object.value, 2)
    XCTAssertEqual(object.value, reference.wrappedValue)
    XCTAssertEqual(object.value, trackedReference.wrappedValue)
    XCTAssertEqual(object.value, handledOnPublish)
    XCTAssertEqual(numberOfPublishedChanges, 3)
    
    cancellable.cancel()
    
    var trackedReferencePublishedValue: Int?
    var trackedReferencePublishedCount = 0
    cancellable = trackedReference.publisher.sink {
      trackedReferencePublishedValue = $0
      trackedReferencePublishedCount += 1
    }
    XCTAssertEqual(trackedReferencePublishedValue, 2)
    XCTAssertEqual(trackedReferencePublishedCount, 1)
    
    reference.wrappedValue = 0
    reference.wrappedValue = 1
    
    XCTAssertEqual(object.value, 1)
    XCTAssertEqual(object.value, reference.wrappedValue)
    XCTAssertEqual(object.value, trackedReference.wrappedValue)
    
    // Tracked reference is a wrapper for the reference here
    // so changes in a lower level (the reference) won't be published
    // by a higher-level trackedReference.publisher
    // but the initial value is always published on subscription
    XCTAssertEqual(trackedReferencePublishedValue, 2)
    XCTAssertEqual(trackedReferencePublishedCount, 1)
  }
}
