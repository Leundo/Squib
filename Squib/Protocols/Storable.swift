//
//  Storable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Storable: Bindable, Plastic, Fluctuating { }
extension Storable {
    public var storedValue: Self? { return self }
    public static func from(_ storableValue: (any Storable)?) throws -> Self {
        if let storableValue = storableValue as? Self { return storableValue }
        throw SquibError.plasticError(storableValue: storableValue)
    }
}


extension String: Storable { }
extension Int64: Storable { }
extension Double: Storable { }
extension Data: Storable { }
