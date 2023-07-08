//
//  Bindable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Bindable {
    associatedtype SpecificStorable: Storable
    var storedValue: SpecificStorable? { get }
}


public protocol StringBindable: Bindable {}
public protocol Int64Bindable: Bindable {}
public protocol DoubleBindable: Bindable {}
public protocol BlobBindable: Bindable {}


extension Optional: Bindable where Wrapped: Bindable {
    public var storedValue: Wrapped.SpecificStorable? {
        if let self = self {
            return self.storedValue
        }
        return nil
    }
}
