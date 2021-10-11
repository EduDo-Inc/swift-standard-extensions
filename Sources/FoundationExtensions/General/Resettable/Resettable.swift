import DeclarativeConfiguration

@propertyWrapper
@dynamicMemberLookup
public class Resettable<Object> {
  public init(_ object: Object) {
    self.object = object
    self.pointer = Pointer(undo: nil, redo: nil)
  }
  
  private var object: Object
  public var wrappedValue: Object { object }
  public var projectedValue: Resettable { self }
  
  private var pointer: Pointer
  
  // MARK: - Undo/Redo
  
  @discardableResult
  public func undo() -> Resettable {
    pointer = pointer.undo(&object)
    return self
  }
  
  @discardableResult
  public func redo() -> Resettable {
    pointer = pointer.redo(&object)
    return self
  }
  
  @discardableResult
  public func reset() -> Resettable {
    while pointer !== undo().pointer {}
    return self
  }
  
  @discardableResult
  public func restore() -> Resettable {
    while pointer !== redo().pointer {}
    return self
  }
  
  // MARK: - Unsafe modification
  
  @discardableResult
  private func __modify(
    _ nextPointer: () -> Pointer
  ) -> Resettable {
    self.pointer = nextPointer()
    return self
  }
  
  @discardableResult
  public func _modify<Value>(
    _ keyPath: FunctionalKeyPath<Object, Value>,
    using action: @escaping (inout Value) -> Void
  ) -> Resettable {
    __modify {
      pointer.apply(
        modification: action,
        for: &object, keyPath
      )
    }
  }
  
  @discardableResult
  public func _modify<Value>(
    _ keyPath: FunctionalKeyPath<Object, Value>,
    using action: @escaping (inout Value) -> Void,
    undo: @escaping (inout Value) -> Void
  ) -> Resettable {
    __modify {
      pointer.apply(
        modification: action,
        for: &object, keyPath,
        undo: undo
      )
    }
  }
  
  @discardableResult
  public func _modify(
    using action: @escaping (inout Object) -> Void,
    undo: @escaping (inout Object) -> Void
  ) -> Resettable {
    __modify {
      pointer.apply(
        modification: action,
        undo: undo,
        for: &object
      )
    }
  }
  
  // MARK: - DynamicMemberLookup
  
  // MARK: Default
  
  public subscript<Value>(
    dynamicMember keyPath: WritableKeyPath<Object, Value>
  ) -> WritableKeyPathContainer<Value> {
    WritableKeyPathContainer(
      resettable: self,
      keyPath: .init(keyPath)
    )
  }
  
  public subscript<Value>(
    dynamicMember keyPath: KeyPath<Object, Value>
  ) -> KeyPathContainer<Value> {
    KeyPathContainer(
      resettable: self,
      keyPath: .getonly(keyPath)
    )
  }
  
  // MARK: Optional
  
  public subscript<Value, Wrapped>(
    dynamicMember keyPath: WritableKeyPath<Wrapped, Value>
  ) -> WritableKeyPathContainer<Value?> where Object == Optional<Wrapped> {
    WritableKeyPathContainer<Value?>(
      resettable: self,
      keyPath: FunctionalKeyPath(keyPath).optional()
    )
  }
  
  public subscript<Value, Wrapped>(
    dynamicMember keyPath: KeyPath<Wrapped, Value>
  ) -> KeyPathContainer<Value?> where Object == Optional<Wrapped> {
    KeyPathContainer<Value?>(
      resettable: self,
      keyPath: FunctionalKeyPath.getonly(keyPath).optional()
    )
  }
  
  // MARK: Collection
  
  public subscript<Value>(
    dynamicMember keyPath: WritableKeyPath<Object, Value>
  ) -> WritableCollectionProxy<Value> where Value: Swift.Collection {
    WritableCollectionProxy<Value>(
      resettable: self,
      keyPath: .init(keyPath)
    )
  }
  
  public subscript<Value>(
    dynamicMember keyPath: KeyPath<Object, Value>
  ) -> CollectionProxy<Value> where Value: Swift.Collection {
    CollectionProxy<Value>(
      resettable: self,
      keyPath: .getonly(keyPath)
    )
  }
}

// MARK: - Undo/Redo Core

extension Resettable {
  private class Pointer {
    init(
      prev: Pointer? = nil,
      next: Pointer? = nil,
      undo: ((inout Object) -> Void)? = nil,
      redo: ((inout Object) -> Void)? = nil
    ) {
      self.prev = prev
      self.next = next
      self._undo = undo
      self._redo = redo
    }
    
    var prev: Pointer?
    var next: Pointer?
    var _undo: ((inout Object) -> Void)?
    var _redo: ((inout Object) -> Void)?
    
    // MARK: - Undo/Redo
    
    func undo(_ object: inout Object) -> Pointer {
      _undo?(&object)
      return prev.or(self)
    }
    
    func redo(_ object: inout Object) -> Pointer {
      _redo?(&object)
      return next.or(self)
    }
    
    // MARK: - Apply
    
    func apply<Value>(
      modification action: @escaping (inout Value) -> Void,
      for object: inout Object,
      _ keyPath: FunctionalKeyPath<Object, Value>
    ) -> Pointer {
      let valueSnapshot = keyPath.extract(from: object)
      return apply(
        modification: action,
        for: &object,
        keyPath,
        undo: { $0 = valueSnapshot }
      )
    }
    
    func apply<Value>(
      modification action: @escaping (inout Value) -> Void,
      for object: inout Object,
      _ keyPath: FunctionalKeyPath<Object, Value>,
      undo: @escaping (inout Value) -> Void
    ) -> Pointer {
      return apply(
        modification: { object in
          keyPath.embed(
            modification(
              of: keyPath.extract(from: object),
              with: action
            ),
            in: &object
          )
        },
        undo: { object in
          keyPath.embed(
            modification(
              of: keyPath.extract(from: object),
              with: undo
            ),
            in: &object
          )
        },
        for: &object
      )
    }
    
    func apply(
      modification: @escaping (inout Object) -> Void,
      undo: @escaping (inout Object) -> Void,
      for object: inout Object
    ) -> Pointer {
      let pointer = Pointer(
        prev: self,
        undo: undo
      )
      
      modification(&object)
      self.next = pointer
      self._redo = modification
      
      return pointer
    }
  }
}

// MARK: Modification public API

extension Resettable {
  @dynamicMemberLookup
  public struct KeyPathContainer<Value> {
    let resettable: Resettable
    let keyPath: FunctionalKeyPath<Object, Value>
    
    // MARK: - DynamicMemberLookup
    
    // MARK: Default
    
    public subscript<LocalValue>(
      dynamicMember keyPath: ReferenceWritableKeyPath<Value, LocalValue>
    ) -> WritableKeyPathContainer<LocalValue> {
      WritableKeyPathContainer<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .init(keyPath))
      )
    }
    
    public subscript<LocalValue>(
      dynamicMember keyPath: KeyPath<Value, LocalValue>
    ) -> KeyPathContainer<LocalValue> {
      KeyPathContainer<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .getonly(keyPath))
      )
    }
    
    // MARK: Optional
    
    public subscript<LocalValue, Wrapped>(
      dynamicMember keyPath: ReferenceWritableKeyPath<Wrapped, LocalValue>
    ) -> WritableKeyPathContainer<LocalValue?> where Value == Optional<Wrapped> {
      WritableKeyPathContainer<LocalValue?>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .init(keyPath))
      )
    }
    
    public subscript<LocalValue, Wrapped>(
      dynamicMember keyPath: KeyPath<Wrapped, LocalValue>
    ) -> KeyPathContainer<LocalValue?> where Value == Optional<Wrapped> {
      KeyPathContainer<LocalValue?>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .getonly(keyPath))
      )
    }
    
    // MARK: Collection
    
    public subscript<LocalValue>(
      dynamicMember keyPath: ReferenceWritableKeyPath<Value, LocalValue>
    ) -> WritableCollectionProxy<LocalValue> where LocalValue: Swift.Collection {
      WritableCollectionProxy<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .init(keyPath))
      )
    }
    
    public subscript<LocalValue>(
      dynamicMember keyPath: KeyPath<Value, LocalValue>
    ) -> CollectionProxy<LocalValue> where LocalValue: Swift.Collection {
      CollectionProxy<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .getonly(keyPath))
      )
    }
  }
  
  @dynamicMemberLookup
  public struct WritableKeyPathContainer<Value> {
    let resettable: Resettable
    let keyPath: FunctionalKeyPath<Object, Value>
    
    // MARK: Modification
    
    @discardableResult
    public func callAsFunction(_ value: Value) -> Resettable {
      return self.callAsFunction { $0 = value }
    }
    
    @discardableResult
    public func callAsFunction(_ action: @escaping (inout Value) -> Void) -> Resettable {
      return resettable._modify(keyPath, using: action)
    }
    
    @discardableResult
    public func callAsFunction(
      _ action: @escaping (inout Value) -> Void,
      undo: @escaping (inout Value) -> Void
    ) -> Resettable {
      return resettable._modify(keyPath, using: action, undo: undo)
    }
    
    
    // MARK: - DynamicMemberLookup
    
    // MARK: Default
    
    public subscript<LocalValue>(
      dynamicMember keyPath: WritableKeyPath<Value, LocalValue>
    ) -> WritableKeyPathContainer<LocalValue> {
      WritableKeyPathContainer<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .init(keyPath))
      )
    }
    
    public subscript<LocalValue>(
      dynamicMember keyPath: KeyPath<Value, LocalValue>
    ) -> KeyPathContainer<LocalValue> {
      KeyPathContainer<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .getonly(keyPath))
      )
    }
    
    // MARK: Optional
    
    public subscript<LocalValue, Wrapped>(
      dynamicMember keyPath: WritableKeyPath<Wrapped, LocalValue>
    ) -> WritableKeyPathContainer<LocalValue?> where Value == Optional<Wrapped> {
      WritableKeyPathContainer<LocalValue?>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .init(keyPath))
      )
    }
    
    public subscript<LocalValue, Wrapped>(
      dynamicMember keyPath: KeyPath<Wrapped, LocalValue>
    ) -> KeyPathContainer<LocalValue?> where Value == Optional<Wrapped> {
      KeyPathContainer<LocalValue?>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .getonly(keyPath))
      )
    }
    
    // MARK: Collection
    
    public subscript<LocalValue>(
      dynamicMember keyPath: WritableKeyPath<Value, LocalValue>
    ) -> WritableCollectionProxy<LocalValue> where LocalValue: Swift.Collection {
      WritableCollectionProxy<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .init(keyPath))
      )
    }
    
    public subscript<LocalValue>(
      dynamicMember keyPath: KeyPath<Value, LocalValue>
    ) -> CollectionProxy<LocalValue> where LocalValue: Swift.Collection {
      CollectionProxy<LocalValue>(
        resettable: resettable,
        keyPath: self.keyPath.appending(path: .getonly(keyPath))
      )
    }
  }
}

#warning("TODO: Move to DeclarativeConfiguration")
extension FunctionalKeyPath {
  func embed(_ value: Value, in root: inout Root) {
    root = embed(value, in: root)
  }
}

extension FunctionalKeyPath {
  public static func getonlyIndex(_ index: Root.Index) -> FunctionalKeyPath
  where Root: Collection, Value == Root.Element {
    FunctionalKeyPath(
      embed: { _, root in return root },
      extract: { $0[index] }
    )
  }
  
  public static func index(_ index: Root.Index) -> FunctionalKeyPath
  where Root: MutableCollection, Value == Root.Element {
    FunctionalKeyPath(
      embed: { value, root in
        modification(of: root) { root in
          root[index] = value
        }
      },
      extract: { root in
        root[index]
      }
    )
  }
  
  public static func safeIndex(_ index: Root.Index) -> FunctionalKeyPath<Root, Value?>
  where Root == Array<Value> {
    FunctionalKeyPath<Root, Value?>(
      embed: { value, root in
        modification(of: root) { root in
          root[safe: index] = value
        }
      },
      extract: { $0[safe: index] }
    )
  }
}
