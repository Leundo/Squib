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
    private var storedItems: [Storehouse.Key: Any] = [:]
    private var storedPhantoms: [ObjectIdentifier: Any] = [:]
    
    private init() {}
    
    func getItem<T>(_ base: Any.Type, _ signature: String, initialize: () -> T) -> T {
        let key = Key(base, signature)
        if let item = storedItems[key] {
            return item as! T
        }
        let item = initialize()
        storedItems[key] = item
        return item
    }
    
    func setItem(_ base: Any.Type, _ signature: String, item: Any) {
        storedItems[Key(base, signature)] = item
    }
    
    func getPhantom<T>(_ base: Any.Type, initialize: () -> T) -> T {
        let key = ObjectIdentifier(base)
        if let phantom = storedPhantoms[key] {
            return phantom as! T
        }
        let item = initialize()
        storedPhantoms[key] = item
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
