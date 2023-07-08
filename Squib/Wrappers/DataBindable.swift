//
//  DataBindable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


@propertyWrapper
public struct DataBindable<WrappedValue: Codable>: Fluctuating, BlobBindable {
    public typealias SpecificStorable = Data
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: Data? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(wrappedValue) else {
            fatalError("DataBindable \(String(describing: wrappedValue))")
        }
        return data
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> DataBindable<WrappedValue> {
        if let storableValue = storableValue as? Data {
            let decoder = JSONDecoder()
            return DataBindable<WrappedValue>(wrappedValue: try decoder.decode(WrappedValue.self, from: storableValue))
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension DataBindable: Equatable where WrappedValue: Equatable {}
extension DataBindable: Hashable where WrappedValue: Hashable {}
