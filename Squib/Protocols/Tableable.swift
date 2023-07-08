//
//  Tableable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public protocol Tableable {
    init()
    static var tableInfo: TableInfo { get }
}


extension Tableable {
    internal static var tableInfoDetail: TableInfo.Detail {
        return Storehouse.shared.getItem(Self.self, "Tableable-tableInfoDetail") {
            return TableInfo.Detail(columnDescriptions: Mirror(reflecting: Self.init()).children.compactMap{
                return $0.value as? ColumnableBridge
            }.map { value in
                if MetatypeManager.int64BindableTypes.contains(where: {value.valueType == $0 }) {
                    return columnDescription(value.name, Datatype.interger, value.constraint)
                } else if MetatypeManager.doubleBindableTypes.contains(where: {value.valueType == $0 }) {
                    return columnDescription(value.name, Datatype.real, value.constraint)
                } else if MetatypeManager.stringBindableTypes.contains(where: {value.valueType == $0 }) {
                    return columnDescription(value.name, Datatype.text, value.constraint)
                } else if MetatypeManager.blobBindableTypes.contains(where: {value.valueType == $0 }) {
                    return columnDescription(value.name, Datatype.blob, value.constraint)
                }
                fatalError("could not process \(value.valueType)")
            })
        }
    }
}


public struct TableInfo {
    var name: String
    var connection: String?
    var constraints: [Constraint.Table]
    
    init(name: String, connection: String?, constraints: [Constraint.Table]) {
        self.name = name
        self.connection = connection
        self.constraints = constraints
    }
    
    public struct Detail {
        var columnDescriptions: [columnDescription]
        
        init(columnDescriptions: [columnDescription]) {
            self.columnDescriptions = columnDescriptions
        }
    }
}


public struct columnDescription {
    public var name: String
    public var type: Datatype
    public var constrain: Constraint.Column
    
    public init(_ name: String, _ type: Datatype, _ constrain: Constraint.Column) {
        self.name = name
        self.type = type
        self.constrain = constrain
    }
}


public enum Datatype: Int, Hashable {
    case interger = 1
    case real = 2
    case text = 3
    case blob = 4
    case null = 5
    
    internal var swiftType: Any.Type? {
        switch self {
        case .interger:
            return Int64.self
        case .real:
            return Double.self
        case .text:
            return String.self
        case .blob:
            return Blob.self
        case .null:
            return nil
        }
    }
}


extension Datatype: CustomStringConvertible {
    public var description: String {
        switch self {
        case .interger:
            return "INTEGER"
        case .real:
            return "REAL"
        case .text:
            return "TEXT"
        case .blob:
            return "BLOB"
        case .null:
            return "NULL"
        }
    }
}
