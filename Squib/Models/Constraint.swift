//
//  Constraint.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public struct Constraint {}


extension Constraint {
    public struct Column: OptionSet, Expressive {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        static let notNull = Column(rawValue: 1 << 0)
        static let primaryKey = Column(rawValue: 1 << 1)
        static let autoIncrement = Column(rawValue: 1 << 2)
        static let unique = Column(rawValue: 1 << 3)
        
        public var incantation: String {
            var expression = ""
            if self.contains(Column.notNull) {
                expression += "NOT NULL "
            }
            if self.contains(Column.primaryKey) {
                expression += "PRIMARY KEY "
            }
            if self.contains(Column.autoIncrement) {
                expression += "AUTOINCREMENT "
            }
            if self.contains(Column.unique) {
                expression += "UNIQUE "
            }
            return expression.trimmingCharacters(in: .whitespaces)
        }
    }
}


extension Constraint {
    public enum Table: Expressive {
        case unique(names: [String])
        case primaryKey(names: [String], isAutoIncrement: Bool = false)
        
        public var incantation: String {
            switch self {
            case let .unique(names):
                if names.count == 0 {
                    fatalError("column name set in table unique constraint is empty")
                }
                return Knife.concat(names, delimiter: ", ", head: "UNIQUE(", end: ")")
            case let .primaryKey(names, isAutoIncrement):
                if names.count == 0 {
                    fatalError("column name set in table primary key constraint is empty")
                }
                if isAutoIncrement, names.count > 1 {
                    fatalError("count of item in column name set in table primary key and autoIncrement constraint is greater than 1")
                }
                let end = isAutoIncrement ? " AUTOINCREMENT)" : ")"
                return Knife.concat(names, delimiter: ", ", head: "PRIMARY KEY(", end: end)
            }
        }
    }
}
