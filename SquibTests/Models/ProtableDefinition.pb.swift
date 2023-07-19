// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: ProtableDefinition.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct ProtablePronunciation {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var symbol: String = String()

  var tone: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ProtableParagraph {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var language: Int32 = 0

  var epitome: String = String()

  var detail: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ProtableParagraphGroup {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var protableParagraph: [ProtableParagraph] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct ProtableDefinition {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var hinshiSet: Int64 {
    get {return _storage._hinshiSet}
    set {_uniqueStorage()._hinshiSet = newValue}
  }

  var pronunciation: ProtablePronunciation {
    get {return _storage._pronunciation ?? ProtablePronunciation()}
    set {_uniqueStorage()._pronunciation = newValue}
  }
  /// Returns true if `pronunciation` has been explicitly set.
  var hasPronunciation: Bool {return _storage._pronunciation != nil}
  /// Clears the value of `pronunciation`. Subsequent reads from it will return its default value.
  mutating func clearPronunciation() {_uniqueStorage()._pronunciation = nil}

  var meanings: ProtableParagraphGroup {
    get {return _storage._meanings ?? ProtableParagraphGroup()}
    set {_uniqueStorage()._meanings = newValue}
  }
  /// Returns true if `meanings` has been explicitly set.
  var hasMeanings: Bool {return _storage._meanings != nil}
  /// Clears the value of `meanings`. Subsequent reads from it will return its default value.
  mutating func clearMeanings() {_uniqueStorage()._meanings = nil}

  var examples: ProtableParagraphGroup {
    get {return _storage._examples ?? ProtableParagraphGroup()}
    set {_uniqueStorage()._examples = newValue}
  }
  /// Returns true if `examples` has been explicitly set.
  var hasExamples: Bool {return _storage._examples != nil}
  /// Clears the value of `examples`. Subsequent reads from it will return its default value.
  mutating func clearExamples() {_uniqueStorage()._examples = nil}

  var subDefinitions: ProtableDefinition {
    get {return _storage._subDefinitions ?? ProtableDefinition()}
    set {_uniqueStorage()._subDefinitions = newValue}
  }
  /// Returns true if `subDefinitions` has been explicitly set.
  var hasSubDefinitions: Bool {return _storage._subDefinitions != nil}
  /// Clears the value of `subDefinitions`. Subsequent reads from it will return its default value.
  mutating func clearSubDefinitions() {_uniqueStorage()._subDefinitions = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

#if swift(>=5.5) && canImport(_Concurrency)
extension ProtablePronunciation: @unchecked Sendable {}
extension ProtableParagraph: @unchecked Sendable {}
extension ProtableParagraphGroup: @unchecked Sendable {}
extension ProtableDefinition: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension ProtablePronunciation: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ProtablePronunciation"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "symbol"),
    2: .same(proto: "tone"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.symbol) }()
      case 2: try { try decoder.decodeSingularSInt32Field(value: &self.tone) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.symbol.isEmpty {
      try visitor.visitSingularStringField(value: self.symbol, fieldNumber: 1)
    }
    if self.tone != 0 {
      try visitor.visitSingularSInt32Field(value: self.tone, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ProtablePronunciation, rhs: ProtablePronunciation) -> Bool {
    if lhs.symbol != rhs.symbol {return false}
    if lhs.tone != rhs.tone {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ProtableParagraph: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ProtableParagraph"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "language"),
    2: .same(proto: "epitome"),
    3: .same(proto: "detail"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularSInt32Field(value: &self.language) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.epitome) }()
      case 3: try { try decoder.decodeRepeatedStringField(value: &self.detail) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.language != 0 {
      try visitor.visitSingularSInt32Field(value: self.language, fieldNumber: 1)
    }
    if !self.epitome.isEmpty {
      try visitor.visitSingularStringField(value: self.epitome, fieldNumber: 2)
    }
    if !self.detail.isEmpty {
      try visitor.visitRepeatedStringField(value: self.detail, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ProtableParagraph, rhs: ProtableParagraph) -> Bool {
    if lhs.language != rhs.language {return false}
    if lhs.epitome != rhs.epitome {return false}
    if lhs.detail != rhs.detail {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ProtableParagraphGroup: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ProtableParagraphGroup"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "protableParagraph"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.protableParagraph) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.protableParagraph.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.protableParagraph, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ProtableParagraphGroup, rhs: ProtableParagraphGroup) -> Bool {
    if lhs.protableParagraph != rhs.protableParagraph {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ProtableDefinition: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ProtableDefinition"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "hinshiSet"),
    2: .same(proto: "pronunciation"),
    3: .same(proto: "meanings"),
    4: .same(proto: "examples"),
    5: .same(proto: "subDefinitions"),
  ]

  fileprivate class _StorageClass {
    var _hinshiSet: Int64 = 0
    var _pronunciation: ProtablePronunciation? = nil
    var _meanings: ProtableParagraphGroup? = nil
    var _examples: ProtableParagraphGroup? = nil
    var _subDefinitions: ProtableDefinition? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _hinshiSet = source._hinshiSet
      _pronunciation = source._pronunciation
      _meanings = source._meanings
      _examples = source._examples
      _subDefinitions = source._subDefinitions
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularSFixed64Field(value: &_storage._hinshiSet) }()
        case 2: try { try decoder.decodeSingularMessageField(value: &_storage._pronunciation) }()
        case 3: try { try decoder.decodeSingularMessageField(value: &_storage._meanings) }()
        case 4: try { try decoder.decodeSingularMessageField(value: &_storage._examples) }()
        case 5: try { try decoder.decodeSingularMessageField(value: &_storage._subDefinitions) }()
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every if/case branch local when no optimizations
      // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
      // https://github.com/apple/swift-protobuf/issues/1182
      if _storage._hinshiSet != 0 {
        try visitor.visitSingularSFixed64Field(value: _storage._hinshiSet, fieldNumber: 1)
      }
      try { if let v = _storage._pronunciation {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      } }()
      try { if let v = _storage._meanings {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      } }()
      try { if let v = _storage._examples {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      } }()
      try { if let v = _storage._subDefinitions {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      } }()
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: ProtableDefinition, rhs: ProtableDefinition) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._hinshiSet != rhs_storage._hinshiSet {return false}
        if _storage._pronunciation != rhs_storage._pronunciation {return false}
        if _storage._meanings != rhs_storage._meanings {return false}
        if _storage._examples != rhs_storage._examples {return false}
        if _storage._subDefinitions != rhs_storage._subDefinitions {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}