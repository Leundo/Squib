//
//  Bindable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Bindable {
    associatedtype StorableType: Storable
    var storedValue: StorableType? { get }
}


extension Optional: Bindable where Wrapped: Bindable {
    public var storedValue: Wrapped.StorableType? {
        if let self = self {
            return self.storedValue
        }
        return nil
    }
}
