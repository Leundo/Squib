//
//  Columnable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


@propertyWrapper
public struct Columnable<Value: Fluctuating>: ColumnableBridge {
    let constraint: Constraint.Column
    let name: String
    let valueType: Any.Type
    var value: any Fluctuating
    
    public var wrappedValue: Value {
        get {
            return value as! Value
        }
        set {
            value = newValue
        }
    }
    
    public init(wrappedValue value: Value, _ name: String, constraint: Constraint.Column = Constraint.Column(rawValue: 0)) {
        self.value = value
        self.constraint = constraint
        self.name = name
        self.valueType = Value.self
    }
}


internal protocol ColumnableBridge {
    var constraint: Constraint.Column { get }
    var name: String { get }
    var valueType: Any.Type { get }
    var value: any Fluctuating { get set }
}


extension Columnable: Equatable where Value: Equatable {
    public static func == (lhs: Columnable<Value>, rhs: Columnable<Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}


extension Columnable: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Value.self))
        hasher.combine(wrappedValue)
    }
}


@propertyWrapper
public struct IgnoreHashableColumnable<Value: Fluctuating>: ColumnableBridge, Hashable {
    let constraint: Constraint.Column
    let name: String
    let valueType: Any.Type
    var value: any Fluctuating
    
    public var wrappedValue: Value {
        get {
            return value as! Value
        }
        set {
            value = newValue
        }
    }
    
    public init(wrappedValue value: Value, _ name: String, constraint: Constraint.Column = Constraint.Column(rawValue: 0)) {
        self.value = value
        self.constraint = constraint
        self.name = name
        self.valueType = Value.self
    }
    public static func == (lhs: IgnoreHashableColumnable<Value>, rhs: IgnoreHashableColumnable<Value>) -> Bool {
        true
    }
    public func hash(into hasher: inout Hasher) {}
}


@propertyWrapper
internal struct IgnoreEquatable<Wrapped>: Equatable {
    internal var wrappedValue: Wrapped

    internal static func == (lhs: IgnoreEquatable<Wrapped>, rhs: IgnoreEquatable<Wrapped>) -> Bool {
        true
    }
}


@propertyWrapper
internal struct IgnoreHashable<Wrapped>: Hashable {
    @IgnoreEquatable internal var wrappedValue: Wrapped

    internal func hash(into hasher: inout Hasher) {}
}
