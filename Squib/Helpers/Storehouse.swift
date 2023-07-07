//
//  Storehouse.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


internal struct HashableMetatype: Hashable {
    fileprivate let type: Any.Type
    
    internal init(_ type: Any.Type) {
        self.type = type
    }
    
    internal func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
    
    static func ==(lhs: HashableMetatype, rhs: HashableMetatype) -> Bool {
        return lhs.type == rhs.type
    }
}


internal class Storehouse {
    internal static let shared = Storehouse()
    private var storedBoxes: [Storehouse.Key: Any] = [:]
    
    private init() {}
    
    func getItem<T>(_ base: Any.Type, _ signature: String, initialize: () -> T) -> T {
        let key = Key(base, signature)
        if let item = storedBoxes[key] {
            return item as! T
        }
        let item = initialize()
        storedBoxes[key] = item
        return item
    }
}


extension Storehouse {
    fileprivate struct Key: Hashable {
        fileprivate var metatype: HashableMetatype
        fileprivate var signature: String
        
        init(_ type: Any.Type, _ signature: String) {
            self.metatype = HashableMetatype(type)
            self.signature = signature
        }
    }
}
