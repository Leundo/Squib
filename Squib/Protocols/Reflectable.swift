//
//  Reflectable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


// MARK: - BasicReflectable
public protocol BasicReflectable {
    func getReflectedValue(_ column: String) -> (any Fluctuating)?
    func getReflectedValues(_ columns: [String]) -> [(any Fluctuating)?]
}


extension BasicReflectable {
    public func getReflectedValue(_ column: Address.Column) -> (any Fluctuating)? {
        return self.getReflectedValue(column.name)
    }
    
    public func getReflectedValues(_ columns: [Address.Column]) -> [(any Fluctuating)?] {
        return self.getReflectedValues(columns.map{$0.name})
    }
}


extension Dictionary: BasicReflectable where Key == String, Value: Fluctuating {
    public func getReflectedValue(_ column: String) -> (any Fluctuating)? {
        if let value = self[column] {
            return value
        } else {
            return nil
        }
    }
    public func getReflectedValues(_ columns: [String]) -> [(any Fluctuating)?] {
        return columns.map {self.getReflectedValue($0)}
    }
}


// MARK: - Reflectable
public protocol Reflectable: BasicReflectable {}


extension Reflectable {
    public func getReflectedValue(_ column: String) -> (any Fluctuating)? {
        for child in Mirror(reflecting: self).children {
            if let value = child.value as? (any ColumnableBridge), value.name == column {
                return value.value
            }
        }
        return nil
    }
    
    public func getReflectedValues(_ columns: [String]) -> [(any Fluctuating)?] {
        var results = Array<(any Fluctuating)?>(repeating: nil, count: columns.count)
        for child in Mirror(reflecting: self).children {
            if let value = child.value as? (any ColumnableBridge), let index = columns.firstIndex(where: {$0 == value.name}) {
                results[index] = value.value
            }
        }
        return results
    }
}
