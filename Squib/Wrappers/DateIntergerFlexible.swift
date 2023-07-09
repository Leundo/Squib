//
//  DateIntergerFlexible.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


@propertyWrapper
public struct DateIntergerFlexible: Fluctuating, Int64Bindable, Hashable, Codable {
    public var wrappedValue: Date
    
    public init(wrappedValue value: Date) {
        self.wrappedValue = value
    }
    
    public var storedValue: Int64? {
        return Int64(wrappedValue.timeIntervalSince1970)
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> DateIntergerFlexible {
        switch storableValue {
        case .none:
            throw SquibError.plasticError(storableValue: storableValue)
        case let storableValue as Int64:
            return DateIntergerFlexible(wrappedValue: Date(timeIntervalSince1970: TimeInterval(storableValue)))
        case .some(let storableValue):
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


@propertyWrapper
public struct OptionalDateIntergerFlexible: Fluctuating, Int64Bindable, Hashable, Codable {
    public var wrappedValue: Date?
    
    public init(wrappedValue value: Date?) {
        self.wrappedValue = value
    }
    
    public var storedValue: Int64? {
        if let wrappedValue = wrappedValue {
            return Int64(wrappedValue.timeIntervalSince1970)
        }
        return nil
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> OptionalDateIntergerFlexible {
        switch storableValue {
        case .none:
            return OptionalDateIntergerFlexible(wrappedValue: nil)
        case let storableValue as Int64:
            return OptionalDateIntergerFlexible(wrappedValue: Date(timeIntervalSince1970: TimeInterval(storableValue)))
        case .some(let storableValue):
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


@propertyWrapper
public struct DateTextFlexible: Fluctuating, StringBindable, Hashable, Codable {
    public var wrappedValue: Date
    
    public init(wrappedValue value: Date) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        return Configuration.customizedDateFormatter.string(from: wrappedValue)
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> DateTextFlexible {
        switch storableValue {
        case .none:
            throw SquibError.plasticError(storableValue: storableValue)
        case let storableValue as String:
            if let date = Configuration.customizedDateFormatter.date(from: storableValue) {
                return DateTextFlexible(wrappedValue: date)
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


@propertyWrapper
public struct OptionalDateTextFlexible: Fluctuating, StringBindable, Hashable, Codable {
    public var wrappedValue: Date?
    
    public init(wrappedValue value: Date?) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        if let wrappedValue = wrappedValue {
            return Configuration.customizedDateFormatter.string(from: wrappedValue)
        }
        return nil
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> OptionalDateTextFlexible {
        switch storableValue {
        case .none:
            return OptionalDateTextFlexible(wrappedValue: nil)
        case let storableValue as String:
            if let date = Configuration.customizedDateFormatter.date(from: storableValue) {
                return OptionalDateTextFlexible(wrappedValue: date)
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
