//
//  SharpArrayBindable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


//public protocol SharpArrayBindableValueProtocol {
//    associatedtype SharpArrayBindableWrappedValueArrayElement: StringBindable & Plastic
//    var sharpArrayBindableWrappedValue: (any RangeReplaceableCollection<SharpArrayBindableWrappedValueArrayElement>)? { get }
//}
//
//extension Array: SharpArrayBindableValueProtocol where Element: StringBindable & Plastic {
//    public var sharpArrayBindableWrappedValue: (any RangeReplaceableCollection<Element>)? {
//        return self
//    }
//}
//
//extension Optional: SharpArrayBindableValueProtocol where Wrapped: RangeReplaceableCollection, Wrapped.Element: StringBindable & Plastic {
//    public var sharpArrayBindableWrappedValue: (any RangeReplaceableCollection<Wrapped.Element>)? {
//        return self
//    }
//}
//
//@propertyWrapper
//public struct SharpArrayBindable<WrappedValue: SharpArrayBindableValueProtocol>: Fluctuating, StringBindable {
//    public typealias SpecificStorable = String
//    public var wrappedValue: WrappedValue
//
//
//    public init(wrappedValue value: WrappedValue) {
//        self.wrappedValue = value
//        if WrappedValue.self is ExpressibleByNilLiteral.Type {
//            fatalError("optional types can not support")
//        }
//    }
//
//    public var storedValue: String? {
//        switch wrappedValue.sharpArrayBindableWrappedValue {
//        case .none:
//            return nil
//        case .some(let wrappedValue):
//            return wrappedValue.reduce("") { initialResult, nextPartialResult in
//                return initialResult + nextPartialResult.storedValue! + "#"
//            }
//        }
//    }
//
//    public static func from(_ storableValue: (any Storable)?) throws -> SharpArrayBindable<WrappedValue> {
//        switch storableValue {
//        case .none:
//            return SharpArrayBindable<WrappedValue>(wrappedValue: Optional<WrappedValue>.none)
//        case let storableValue as String:
//            return SharpArrayBindable<WrappedValue>(wrappedValue: try Knife.split(storableValue, delimiter: "#").map {
//                return try WrappedValue.from($0)
//            })
//        case .some(let storableValue):
//            throw SquibError.plasticError(storableValue: storableValue)
//        }
//    }
//
//    public var incantation: String {
//        return storedValue.incantation
//    }
//
//}
//
//
//extension SharpArrayBindable: Equatable where WrappedValue: Equatable {
//    public static func == (lhs: SharpArrayBindable<WrappedValue>, rhs: SharpArrayBindable<WrappedValue>) -> Bool {
//        switch lhs.wrappedValue.sharpArrayBindableWrappedValue {
//        case .none:
//            switch rhs.wrappedValue.sharpArrayBindableWrappedValue {
//            case .none:
//                return true
//            case .some:
//                return false
//            }
//        case .some(let lhsValue):
//            switch rhs.wrappedValue.sharpArrayBindableWrappedValue {
//            case .none:
//                return false
//            case .some(let rhsValue):
//                return Array(lhsValue) as! Array<WrappedValue> == Array(rhsValue) as! Array<WrappedValue>
//            }
//        }
//    }
//}
//extension SharpArrayBindable: Hashable where WrappedValue: Hashable {
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(ObjectIdentifier(WrappedValue.self))
//        hasher.combine(wrappedValue.sharpArrayBindableWrappedValue as! Array<WrappedValue>?)
//    }
//}
//


@propertyWrapper
public struct SharpArrayBindable<Element: StringBindable & Plastic>: Fluctuating, StringBindable {
    public var wrappedValue: Array<Element>
    
    public init(wrappedValue value: Array<Element>) {
        self.wrappedValue = value
        if Element.self is ExpressibleByNilLiteral.Type {
            fatalError("optional types can not support")
        }
    }
    
    public var storedValue: String? {
        return wrappedValue.reduce("") { initialResult, nextPartialResult in
            return initialResult + nextPartialResult.storedValue! + "#"
        }
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> SharpArrayBindable<Element> {
        switch storableValue {
        case .none:
            throw SquibError.plasticError(storableValue: storableValue)
        case let storableValue as String:
            return SharpArrayBindable<Element>(wrappedValue: try Knife.split(storableValue, delimiter: "#").map {
                return try Element.from($0)
            })
        case .some(let storableValue):
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension SharpArrayBindable: Equatable where Element: Equatable {}
extension SharpArrayBindable: Hashable where Element: Hashable {}
