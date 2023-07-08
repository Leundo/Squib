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
    
//    public static func == (lhs: Columnable<Value>, rhs: Columnable<Value>) -> Bool {
//        return lhs.wrappedValue == rhs.wrappedValue && lhs.name == rhs.name && lhs.constraint == rhs.constraint
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(HashableMetatype(Value.self))
//        hasher.combine(value)
//        hasher.combine(name)
//        hasher.combine(constraint.rawValue)
//    }
}


protocol ColumnableBridge {
    var constraint: Constraint.Column { get }
    var name: String { get }
    var valueType: Any.Type { get }
    var value: any Fluctuating { get set }
}
