//
//  Columnable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


@propertyWrapper
public struct Columnable<Value: Fluctuating> {
    let constraint: Constraint.Column
    let name: String
    var value: (any Fluctuating)
    
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
    }
}


protocol ColumnableBridge {
    var constraint: Constraint.Column { get }
    var name: String { get }
    var value: any Fluctuating { get set }
}
