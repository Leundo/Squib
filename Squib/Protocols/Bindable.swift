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


//extension Optional: Bindable where Wrapped: Bindable {
//    public typealias StorableType = Wrapped
//    var storedValue: Wrapped? {
//        return nil
//    }
//}
