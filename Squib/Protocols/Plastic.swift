//
//  Plastic.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Plastic {
    static func from(_ storableValue: Storable?) throws -> Self
}


extension Optional: Plastic where Wrapped: Plastic {
    public static func from(_ storableValue: Storable?) throws -> Self {
        if let storableValue = storableValue {
            return try Wrapped.from(storableValue)
        } else {
            return nil
        }
    }
}
