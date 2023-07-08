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


public protocol StringBindable: Bindable { var storedValue: String? { get } }
public protocol Int64Bindable: Bindable { var storedValue: Int64? { get } }
public protocol DoubleBindable: Bindable { var storedValue: Double? { get } }
public protocol DataBindable: Bindable { var storedValue: Data? { get } }

extension String: StringBindable {}
extension Date: StringBindable {}

extension Data: DataBindable {}

extension Optional: Bindable where Wrapped: Bindable {
    public var storedValue: Wrapped.SpecificStorable? {
        if let self = self {
            return self.storedValue
        }
        return nil
    }
}

extension Optional: StringBindable where Wrapped: StringBindable {
    public var storedValue: String? {
        if let self = self {
            return self.storedValue
        }
        return nil
    }
}
