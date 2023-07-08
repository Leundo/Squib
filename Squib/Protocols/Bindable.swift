//
//  Bindable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Bindable {
    associatedtype StorableType: Storable
    var storedValue: StorableType { get }
}


