#if canImport(Combine)
  import Combine
#endif
  
struct CombineSubjectBackport<Output, Failure: Error> {
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public init<S: Subject>(_ subject: S) where S.Output == Output, S.Failure == Failure {
    self._sendValue = subject.send
    self._sendSubscription = {
      guard let subscription = $0 as? Subscription else { return }
      subject.send(subscription: subscription)
    }
    self._sendCompletion = {
      guard let completion = $0 as? Subscribers.Completion<Failure> else { return }
      subject.send(completion: completion)
    }
    self._publisher = subject.eraseToAnyPublisher
  }
  #endif
  
  static func unsupported() -> CombineSubjectBackport { .init() }
  private init() {
    self._sendValue = { _ in }
    self._sendSubscription = { _ in }
    self._sendCompletion = { _ in }
    self._publisher = {
      #if canImport(Combine)
      if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
        return Empty<Output, Failure>().eraseToAnyPublisher()
      }
      #endif
      fatalError("Publisher is unavalible")
    }
  }
  
  private let _sendValue: (Output) -> Void
  private let _sendSubscription: (Any) -> Void
  private let _sendCompletion: (Any) -> Void
  private let _publisher: () -> Any
  
  func send(_ value: Output) {
    _sendValue(value)
  }
  
  #if canImport(Combine)
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func send(subscription: Subscription) {
    _sendSubscription(subscription)
  }
  
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func send(completion: Subscribers.Completion<Failure>) {
    _sendCompletion(completion)
  }
  
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  var publisher: AnyPublisher<Output, Failure> { _publisher() as! AnyPublisher<Output, Failure> }
  #endif
}
