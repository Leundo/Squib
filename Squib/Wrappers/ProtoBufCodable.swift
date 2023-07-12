//
//  ProtoBufCodable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/12.
//

import Foundation
import SwiftProtobuf


@propertyWrapper
public struct ProtoBufCodable<WrappedValue: Message>: Fluctuating, DataBindable {
    public typealias SpecificStorable = Data
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: Data? {
        guard let data = try? wrappedValue.serializedData() else {
            fatalError("JSONDataCodable \(String(describing: wrappedValue))")
        }
        return data
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> ProtoBufCodable<WrappedValue> {
        if let storableValue = storableValue as? Data {
            return ProtoBufCodable<WrappedValue>(wrappedValue: try WrappedValue(serializedData: storableValue))
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension ProtoBufCodable: Equatable where WrappedValue: Equatable {}
extension ProtoBufCodable: Hashable where WrappedValue: Hashable {}
