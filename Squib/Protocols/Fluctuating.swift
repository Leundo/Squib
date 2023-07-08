//
//  Fluctuating.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Fluctuating: Bindable, Plastic, Expressive { }


extension Int: Fluctuating {
    public var storedValue: Int64? { return Int64(self) }
    public var incantation: String { return self.storedValue.incantation }
    public static func from(_ storableValue: (any Storable)?) throws -> Int {
        return Int(try Int64.from(storableValue))
    }
}


extension Bool: Fluctuating {
    public var storedValue: Int64? { return self ? 1 : 0 }
    public var incantation: String { return self.storedValue.incantation }
    public static func from(_ storableValue: (any Storable)?) throws -> Bool {
        return try Int64.from(storableValue) != 0 ? true : false
    }
}


extension Date: Fluctuating {
    public var storedValue: String? { return Constant.dateFormatter.string(from: self) }
    public var incantation: String { return self.storedValue.incantation }
    public static func from(_ storableValue: (any Storable)?) throws -> Date {
        if let storableValue = storableValue as? String, let date = Constant.dateFormatter.date(from: storableValue) {
            return date
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
}


extension Optional: Fluctuating where Wrapped: Bindable, Wrapped: Plastic, Wrapped: Expressive, Wrapped: Hashable {}


//@propertyWrapper
//internal struct IntervalArray<Element> {
//    internal var wrappedValue: Wrapped
//
//}
