//
//  JSONDataCodable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


@propertyWrapper
public struct JSONDataCodable<WrappedValue: Codable>: Fluctuating, DataBindable {
    public typealias SpecificStorable = Data
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: Data? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(wrappedValue) else {
            fatalError("JSONDataCodable \(String(describing: wrappedValue))")
        }
        return data
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> JSONDataCodable<WrappedValue> {
        if let storableValue = storableValue as? Data {
            let decoder = JSONDecoder()
            return JSONDataCodable<WrappedValue>(wrappedValue: try decoder.decode(WrappedValue.self, from: storableValue))
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension JSONDataCodable: Equatable where WrappedValue: Equatable {}
extension JSONDataCodable: Hashable where WrappedValue: Hashable {}
