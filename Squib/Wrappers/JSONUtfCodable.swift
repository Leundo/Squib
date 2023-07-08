//
//  JSONUtfCodable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


@propertyWrapper
public struct JSONUtfCodable<WrappedValue: Codable>: Fluctuating, StringBindable {
    public typealias SpecificStorable = String
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(wrappedValue) else {
            fatalError("JSONUtfCodable \(String(describing: wrappedValue))")
        }
        guard let result = String(data: data, encoding: String.Encoding.utf8) else {
            fatalError("JSONUtfCodable \(String(describing: wrappedValue))")
        }
        return result
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> JSONUtfCodable<WrappedValue> {
        if let storableValue = storableValue as? String, let data = storableValue.data(using: .utf8) {
            let decoder = JSONDecoder()
            return JSONUtfCodable<WrappedValue>(wrappedValue: try decoder.decode(WrappedValue.self, from: data))
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension JSONUtfCodable: Equatable where WrappedValue: Equatable {}
extension JSONUtfCodable: Hashable where WrappedValue: Hashable {}
