//
//  Fluctuating.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Fluctuating: Bindable, Plastic { }


extension Int: Fluctuating {
    public var storedValue: Storable { return Int64(self) }
    public static func from(_ storableValue: Storable?) throws -> Int {
        return Int(try Int64.from(storableValue))
    }
}


extension Bool: Fluctuating {
    public var storedValue: Storable { return self ? 1 : 0 }
    public static func from(_ storableValue: Storable?) throws -> Bool {
        return try Int64.from(storableValue) != 0 ? true : false
    }
}


extension Date: Fluctuating {
    public var storedValue: Storable { return Constant.dateFormatter.string(from: self) }
    public static func from(_ storableValue: Storable?) throws -> Date {
        if let storableValue = storableValue as? String, let date = Constant.dateFormatter.date(from: storableValue) {
            return date
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
}
