//
//  SharpArrayCharacterizable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


@propertyWrapper
public struct SharpArrayCharacterizable<Element: StringBindable & Plastic>: Fluctuating, StringBindable {
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
    
    public static func from(_ storableValue: (any Storable)?) throws -> SharpArrayCharacterizable<Element> {
        switch storableValue {
        case .none:
            throw SquibError.plasticError(storableValue: storableValue)
        case let storableValue as String:
            return SharpArrayCharacterizable<Element>(wrappedValue: try Knife.split(storableValue, delimiter: "#").map {
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


extension SharpArrayCharacterizable: Equatable where Element: Equatable {}
extension SharpArrayCharacterizable: Hashable where Element: Hashable {}


@propertyWrapper
public struct OptionalSharpArrayCharacterizable<Element: StringBindable & Plastic>: Fluctuating, StringBindable {
    public var wrappedValue: Array<Element>?
    
    public init(wrappedValue value: Array<Element>?) {
        self.wrappedValue = value
        if Element.self is ExpressibleByNilLiteral.Type {
            fatalError("optional types can not support")
        }
    }
    
    public var storedValue: String? {
        if let wrappedValue = wrappedValue {
            return wrappedValue.reduce("") { initialResult, nextPartialResult in
                return initialResult + nextPartialResult.storedValue! + "#"
            }
        }
        return nil
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> OptionalSharpArrayCharacterizable<Element> {
        switch storableValue {
        case .none:
            return OptionalSharpArrayCharacterizable<Element>(wrappedValue: nil)
        case let storableValue as String:
            return OptionalSharpArrayCharacterizable<Element>(wrappedValue: try Knife.split(storableValue, delimiter: "#").map {
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


extension OptionalSharpArrayCharacterizable: Equatable where Element: Equatable {}
extension OptionalSharpArrayCharacterizable: Hashable where Element: Hashable {}
