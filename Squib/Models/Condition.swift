//
//  Condition.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public class Condition: Expressive {
    public var incantation: String {
        fatalError("incantation has not been implemented")
    }
    public func weave(_ environment: String?) -> String {
        fatalError("weave has not been implemented")
    }
}


extension Condition {
    public enum Comparator: String {
        case equal = "="
        case notEqual = "!="
        case greaterThan = ">"
        case greaterThanOrEqual = ">="
        case lessThan = "<"
        case lessThanOrEqual = "<="
    }
    
    public struct Trio: Expressive {
        public var lhs: Canister
        public var rhs: Canister
        public var sign: Comparator
        
        public var incantation: String {
            return "\(lhs.incantation) \(sign.rawValue) \(rhs.incantation)"
        }
        public func weave(_ environment: String?) -> String {
            return "\(lhs.weave(environment)) \(sign.rawValue) \(rhs.weave(environment))"
        }
    }
}


 
public class ParallelCondition: Condition {
    public var trios: [Trio] {
        fatalError("trios has not been implemented")
    }
    
    public override var incantation: String {
        if trios.count > 0 {
            return "WHERE " + Knife.concat(trios.map {$0.incantation}, delimiter: " AND ")
        }
        return ""
    }
    public override func weave(_ environment: String?) -> String {
        if trios.count > 0 {
            return "WHERE " + Knife.concat(trios.map {$0.weave(environment)}, delimiter: " AND ")
        }
        return ""
    }
}


public class ArrayLikeParallelCondition: ParallelCondition {
    public override var trios: [Trio] { return _trios }
    private var _trios: [Trio]
    
    public init(_ trios: [Trio]) {
        self._trios = trios
    }
}
