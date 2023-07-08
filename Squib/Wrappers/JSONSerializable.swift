//
//  JSONSerializable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


@propertyWrapper
public struct JSONSerializable<WrappedValue>: Fluctuating, StringBindable {
    public typealias SpecificStorable = String
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: wrappedValue, options: []) else {
            fatalError("JSONSerializable \(String(describing: wrappedValue))")
        }
        guard let result = String(data: data, encoding: String.Encoding.utf8) else {
            fatalError("JSONSerializable \(String(describing: wrappedValue))")
        }
        return result
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> JSONSerializable<WrappedValue> {
        if let storableValue = storableValue as? String, let wrappedValue = try JSONSerialization.jsonObject(with: Data(storableValue.utf8), options: []) as? WrappedValue {
            return JSONSerializable<WrappedValue>(wrappedValue: wrappedValue)
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension JSONSerializable: Equatable where WrappedValue: Equatable {}
extension JSONSerializable: Hashable where WrappedValue: Hashable {}

