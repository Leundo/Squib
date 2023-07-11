//
//  Limitation.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public struct Limitation: Expressive {
    public var number: Int
    public var offset: Int?
    
    public init(number: Int, offset: Int? = nil) {
        self.number = number
        self.offset = offset
    }
    
    public var incantation: String {
        let expression = "LIMIT \(number)"
        if let offset = offset {
            return expression +  " " + "OFFSET \(offset)"
        }
        return expression
    }
}
