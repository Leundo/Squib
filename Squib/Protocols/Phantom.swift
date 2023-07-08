//
//  Phantom.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public protocol Phantom {
    init()
}


extension Phantom {
    public static var phantom: Self {
        return Storehouse.shared.getPhantom(Self.self, initialize: {return Self.init()})
    }
}
