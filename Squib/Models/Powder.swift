//
//  Powder.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation


public class Powder {
    public fileprivate(set) var connection: Connection
    
    init(connection: Connection) {
        self.connection = connection
    }
    
}


// MARK: Attach, Create & Drop
extension Powder {
    public func execute(_ sqls: [String]) throws {
        try connection.execute(sqls)
    }
    
    public func execute(_ sqls: String...) throws {
        if !sqls.isEmpty {
            try execute(sqls)
        }
    }
    
    public func attach(_ connection: Connection) throws {
        try execute(Compiler.attach(connection: connection))
    }
    
    public func create<T: Tableable>(_ C: T.Type) throws {
        try execute(Compiler.create(detailTableInfo: C.detailTableInfo))
    }
    
    public func drop<T: Tableable>(_ C: T.Type) throws {
        try execute(Compiler.drop(table: C.tableInfo.table))
    }
}


// MARK: - Query
extension Powder {
    public func query<T: Tableable & Rebuildable>(_ C: T.Type, condition: Condition? = nil, limitation: Limitation? = nil) throws -> [T] {
        let columns = T.detailTableInfo.columns
        let retrievedRows = try Statement(connection, Compiler.query(tables: [T.tableInfo.table], columns: columns, condition: condition, limitation: limitation, environment: connection.alias)).retrieve()
        return try Array<T>.from(retrievedRows, columns)
    }
    
    public func naturallyQuery<T: Tableable & Rebuildable>(_ C: T.Type, _ Ds: [Any.Type], condition: Condition? = nil, limitation: Limitation? = nil) throws -> [T] {
        let tableAndColumns = Ds.compactMap{ $0 as? Tableable.Type }.map{ ($0.tableInfo.table, $0.detailTableInfo.columns)}
        let columns = tableAndColumns.map{$0.1}.joined()
        let targetColumns = T.detailTableInfo.columns
        let rebuildColumns = columns.map { column in
            return targetColumns.first(where: {$0.name == column.name})?.name
        }
        let retrievedRows = try Statement(connection, Compiler.query(tables: [T.tableInfo.table], columns: targetColumns, condition: condition, limitation: limitation, environment: connection.alias)).retrieve()
        return try Array<T>.from(retrievedRows, rebuildColumns)
    }
}


// MARK: - Replace & Delete
extension Powder {
    public func replace<T: Tableable & Reflectable>(_ object: T, _ key: ColumnKey = .notPrimary) throws {
        let columns = T.columnDictionary[key]!
        try Statement(connection, Compiler.replace(table: T.detailTableInfo.table, columns: columns, environment: connection.alias)).run(object.getReflectedValues(columns))
    }
    
    
    public func replace<T: Tableable & Reflectable, Sequence1: Sequence<T>>(_ objects: Sequence1, _ key: ColumnKey = .notPrimary) throws {
        let columns = T.columnDictionary[key]!
        let statement = try Statement(connection, Compiler.replace(table: T.tableInfo.table, columns: columns, environment: connection.alias))
        for object in objects {
            try statement.run(object.getReflectedValues(columns))
        }
    }
    
    
    public func delete<T: Tableable & Reflectable>(_ object: T, _ key: ColumnKey = .primary) throws {
        let columns = T.columnDictionary[key]!
        let condition = ArrayLikeParallelCondition(columns: columns).bind(object.getReflectedValues(columns))
        try Statement(connection, Compiler.delete(table: T.tableInfo.table, condition: condition, environment: connection.alias)).run()
    }
    
    
    public func delete<T: Tableable & Reflectable, Sequence1: Sequence<T>>(_ objects: Sequence1, _ key: ColumnKey = .primary) throws {
        let columns = T.columnDictionary[key]!
        let condition = ArrayLikeParallelCondition(columns: columns)
        for object in objects {
            try Statement(connection, Compiler.delete(table: T.tableInfo.table, condition: condition.bind(object.getReflectedValues(columns)), environment: connection.alias)).run()
        }
    }
}


// MARK: - Update
extension Powder {
    public func update<T: Tableable & Reflectable>(_ object: T, _ key: ColumnKey = .notPrimary, condition: Condition) throws {
        let columns = T.columnDictionary[key]!
        try Statement(connection, Compiler.update(table: T.tableInfo.table, columns: columns, condition: condition, environment: connection.alias)).run(object.getReflectedValues(columns))
    }
    
    public func update<T: Tableable & Reflectable, Sequence1: Sequence<T>>(_ objects: Sequence1, _ key: ColumnKey = .notPrimary, condition: Condition) throws {
        let columns = T.columnDictionary[key]!
        for object in objects {
            try Statement(connection, Compiler.update(table: T.tableInfo.table, columns: columns, condition: condition, environment: connection.alias)).run(object.getReflectedValues(columns))
        }
    }
    
    public func update<T: Tableable & Reflectable>(_ object: T, _ key: ColumnKey = .notPrimary, conditionColumnKey: ColumnKey = .primary, comparator: Condition.Comparator = .equal) throws {
        let columns = T.columnDictionary[key]!
        let conditionColumns = T.columnDictionary[conditionColumnKey]!
        let condition = ArrayLikeParallelCondition(columns: conditionColumns, comparator).bind(object.getReflectedValues(conditionColumns))
        try Statement(connection, Compiler.update(table: T.tableInfo.table, columns: columns, condition: condition, environment: connection.alias)).run(object.getReflectedValues(columns))
    }
    
    public func update<T: Tableable & Reflectable, Sequence1: Sequence<T>>(_ objects: Sequence1, _ key: ColumnKey = .notPrimary, conditionColumnKey: ColumnKey = .primary, comparator: Condition.Comparator = .equal) throws {
        let columns = T.columnDictionary[key]!
        let conditionColumns = T.columnDictionary[conditionColumnKey]!
        let condition = ArrayLikeParallelCondition(columns: conditionColumns, comparator)
        for object in objects {
            try Statement(connection, Compiler.update(table: T.tableInfo.table, columns: columns, condition: condition.bind(object.getReflectedValues(conditionColumns)), environment: connection.alias)).run(object.getReflectedValues(columns))
        }
    }
}


extension Powder {
    public enum ColumnKey: Hashable {
        case primary
        case notPrimary
        case tableUnique
        case notTableUnique
        case customized(value: Int)
        
        public init(_ value: Int) {
            self = ColumnKey.customized(value: value)
        }
    }
}
