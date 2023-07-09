//
//  RawStringFlexible.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


@propertyWrapper
public struct RawStringLikeFlexible<WrappedValue: RawRepresentable>: Fluctuating, StringBindable where WrappedValue.RawValue: StringProtocol {
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        return String(wrappedValue.rawValue)
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> RawStringLikeFlexible {
        switch storableValue {
        case .none:
            throw SquibError.plasticError(storableValue: storableValue)
        case let storableValue as String:
            if let cString = (storableValue as NSString).utf8String, let value = WrappedValue(rawValue: WrappedValue.RawValue(cString: cString)) {
                return RawStringLikeFlexible(wrappedValue: value)
            }
            throw SquibError.plasticError(storableValue: storableValue)
        case .some(let storableValue):
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension RawStringLikeFlexible: Equatable where WrappedValue: Equatable {}
extension RawStringLikeFlexible: Hashable where WrappedValue: Hashable {}



@propertyWrapper
public struct RawStringFlexible<WrappedValue: RawRepresentable>: Fluctuating, StringBindable where WrappedValue.RawValue == String {
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        return String(wrappedValue.rawValue)
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> RawStringFlexible {
        switch storableValue {
        case .none:
            throw SquibError.plasticError(storableValue: storableValue)
        case let storableValue as String:
            if let value = WrappedValue(rawValue: storableValue) {
                return RawStringFlexible(wrappedValue: value)
            }
            throw SquibError.plasticError(storableValue: storableValue)
        case .some(let storableValue):
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension RawStringFlexible: Equatable where WrappedValue: Equatable {}
extension RawStringFlexible: Hashable where WrappedValue: Hashable {}
