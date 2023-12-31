//
//  Condition.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public class Condition: Expressive {
    fileprivate var incantationWithoutHead: String {
        fatalError("incantation has not been implemented")
    }
    fileprivate func weaveWithoutHead(_ environment: String?) -> String {
        fatalError("weave has not been implemented")
    }
    fileprivate var placeholderCount: Int {
        fatalError("placeholderCount has not been implemented")
    }
    public var incantation: String {
        if incantationWithoutHead.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return ""
        }
        return "WHERE " + incantationWithoutHead
    }
    public func weave(_ environment: String?) -> String {
        let weavedIncantation = weaveWithoutHead(environment).trimmingCharacters(in: .whitespacesAndNewlines)
        if weavedIncantation == "" {
            return ""
        }
        return "WHERE " + weavedIncantation
    }
    @discardableResult public func bind(_ values: ((any Expressive)?)...) -> Condition {
        return bind(values)
    }
    @discardableResult public func bind<Collection1: Collection<(any Expressive)?>>(_ values: Collection1) -> Condition {
//        if values.isEmpty { return self }
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
        case inSet = "IN"
    }
    
    public enum Logic: String {
        case and = " AND "
        case or = " OR "
    }
    
    public enum Canister: Expressive {
        case column(payload: Address.Column)
        case value(payload: any Expressive)
        case expression(payload: String)
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
            case let .expression(payload):
                return payload
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
            case let .expression(payload):
                return payload
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
        
        public init(lhs: Canister, rhs: Canister, sign: Comparator) {
            self.lhs = lhs
            self.rhs = rhs
            self.sign = sign
        }
        
        public var incantation: String {
            return "\(lhs.incantation) \(sign.rawValue) \(rhs.incantation)"
        }
        public func weave(_ environment: String?) -> String {
            return "\(lhs.weave(environment)) \(sign.rawValue) \(rhs.weave(environment))"
        }
    }
}


 
public class ParallelCondition: Condition {
    public var logic: Logic
    public var trios: [Trio] {
        fatalError("trios has not been implemented")
    }
    
    init(logic: Logic = .and) {
        self.logic = logic
    }
    fileprivate override var incantationWithoutHead: String {
        if trios.count > 0 {
            return "(" + Knife.concat(trios.map {$0.incantation}, delimiter: logic.rawValue) + ")"
        }
        return ""
    }
    fileprivate override func weaveWithoutHead(_ environment: String?) -> String {
        if trios.count > 0 {
            return "(" + Knife.concat(trios.map {$0.weave(environment)}, delimiter: logic.rawValue) + ")"
        }
        return ""
    }
}


// MARK: - ParallelBagCondition
public class ParallelBagCondition: Condition {
    public var logic: Logic
    public var condtions: [Condition]
    
    public override var placeholderCount: Int { return _placeholderCount }
    private lazy var _placeholderCount: Int = {
        return condtions.map { $0.placeholderCount }.reduce(0, +)
    }()
    
    public init(condtions: [Condition], _ logic: Logic = .and) {
        self.condtions = condtions
        self.logic = logic
    }
    
    fileprivate override var incantationWithoutHead: String {
        if condtions.count > 0 {
            return "(" + Knife.concat(condtions.map {$0.incantationWithoutHead}, delimiter: logic.rawValue) + ")"
        }
        return ""
    }
    
    fileprivate override func weaveWithoutHead(_ environment: String?) -> String {
        if condtions.count > 0 {
            return "(" + Knife.concat(condtions.map {$0.weaveWithoutHead(environment)}, delimiter: logic.rawValue) + ")"
        }
        return ""
    }
    
    public override func bind<Collection1: Collection<(any Expressive)?>>(_ values: Collection1) -> Condition {
        if values.count != _placeholderCount {
            fatalError("there are \(_placeholderCount) placeholder in condition, but \(values.count) in argument")
        }
        var counter = 0
        let startIndex = values.startIndex
        for index in 0..<condtions.count {
            condtions[index].bind(values[values.index(startIndex, offsetBy:counter)..<values.index(startIndex, offsetBy:counter+condtions[index].placeholderCount)])
            counter += condtions[index].placeholderCount
        }
        return self
    }
}


// MARK: - ArrayLikeParallelCondition
public class ArrayLikeParallelCondition: ParallelCondition {
    public override var trios: [Trio] { return _trios }
    private var _trios: [Trio]
    
    private lazy var valueCount: Int = {
        return trios.map { ($0.lhs.isValue ? 1 : 0) + ($0.rhs.isValue ? 1 : 0) }.reduce(0, +)
    }()
    public override var placeholderCount: Int { return _placeholderCount }
    private lazy var _placeholderCount: Int = {
        return trios.map { ($0.lhs.isPlaceholder ? 1 : 0) + ($0.rhs.isPlaceholder ? 1 : 0) }.reduce(0, +)
    }()
    
    
    public init(_ trios: [Trio], _ logic: Logic = .and) {
        self._trios = trios
        super.init(logic: logic)
    }
    
    public init(columns: [Address.Column], _ comparator: Comparator = .equal, _ logic: Logic = .and) {
//        self._trios = columns.map { Trio(lhs: .placeholder(payload: "", isBound: false), rhs: .column(payload: $0), sign: comparator) }
        self._trios = columns.map { Trio(lhs: .column(payload: $0), rhs: .placeholder(payload: "", isBound: false), sign: comparator) }
        super.init(logic: logic)
    }
    
    public override func bind<Collection1: Collection<(any Expressive)?>>(_ values: Collection1) -> Condition {
        if values.count != _placeholderCount {
            fatalError("there are \(_placeholderCount) placeholder in condition, but \(values.count) in argument")
        }
        var index = values.startIndex
        for group in 0..<_trios.count {
            if _trios[group].lhs.isPlaceholder {
                if let value = values[index] {
                    _trios[group].lhs = .placeholder(payload: value, isBound: true)
                }
                index = values.index(after: index)
            }
            if _trios[group].rhs.isPlaceholder {
                if let value = values[index] {
                    _trios[group].rhs = .placeholder(payload: value, isBound: true)
                }
                index = values.index(after: index)
            }
        }
        return self
    }
}
