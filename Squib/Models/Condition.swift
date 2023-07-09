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
    @discardableResult public func bind(_ values: (any Expressive)...) -> Condition {
        return bind(values)
    }
    @discardableResult public func bind(_ values: [any Expressive]) -> Condition {
        if values.isEmpty { return self }
        fatalError("bind has not been implemented")
    }
    @discardableResult public func reset() -> Condition {
        fatalError("reset has not been implemented")
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
    
    public enum Canister: Expressive {
        case column(payload: Address.Column)
        case value(payload: any Expressive)
        case placeholder(payload: any Expressive, isBound: Bool)
        
        public var incantation: String {
            switch self {
            case let .value(payload):
                return payload.incantation
            case let .placeholder(payload, isBound):
                guard isBound else { return "?" }
                return payload.incantation
            case let .column(payload):
                return payload.incantation
            }
        }
        public func weave(_ environment: String?) -> String {
            switch self {
            case let .value(payload):
                return payload.incantation
            case let .placeholder(payload, isBound):
                guard isBound else { return "?" }
                return payload.incantation
            case let .column(payload):
                return payload.weave(environment)
            }
        }
        public var isValue: Bool {
            if case .value = self {
                return true
            }
            return false
        }
        public var isPlaceholder: Bool {
            if case .placeholder = self {
                return true
            }
            return false
        }
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
    
    private lazy var valueCount: Int = {
        return trios.map { ($0.lhs.isValue ? 1 : 0) + ($0.rhs.isValue ? 1 : 0) }.reduce(0, +)
    }()
    private lazy var placeholderCount: Int = {
        return trios.map { ($0.lhs.isPlaceholder ? 1 : 0) + ($0.rhs.isPlaceholder ? 1 : 0) }.reduce(0, +)
    }()
    
    
    public init(_ trios: [Trio]) {
        self._trios = trios
    }
    
    public init(columns: [Address.Column], _ comparator: Comparator = .equal) {
        self._trios = columns.map { Trio(lhs: .placeholder(payload: "", isBound: false), rhs: .column(payload: $0), sign: comparator) }
    }
    
    public override func bind(_ values: [any Expressive]) -> Condition {
        if values.count != placeholderCount {
            fatalError("there are \(placeholderCount) placeholder in condition, but \(values.count) in argument")
        }
        var index = 0
        for group in 0..<_trios.count {
            if _trios[group].lhs.isPlaceholder {
                _trios[group].lhs = .placeholder(payload: values[index], isBound: true)
                index += 1
            }
            if _trios[group].rhs.isPlaceholder {
                _trios[group].rhs = .placeholder(payload: values[index], isBound: true)
                index += 1
            }
        }
        return self
    }
}
