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
    
    public func query<T: Tableable & Rebuildable>(_ C: T.Type, condition: Condition? = nil, limitation: Limitation? = nil) throws -> [T] {
        let columns = T.detailTableInfo.columns
        let retrievedRows = try Statement(connection, Compiler.query(tables: [T.tableInfo.table], columns: columns, condition: condition, limitation: limitation, environment: connection.alias)).retrieve()
        return try Array<T>.from(retrievedRows, columns)
    }
    
    public func naturallyQuery<T: Tableable & Rebuildable>(_ C: T.Type, _ Ds: [Any.Type], limitation: Limitation? = nil) throws {
        let tableAndColumns = Ds.compactMap{ $0 as? Tableable.Type }.map{ ($0.tableInfo.table, $0.detailTableInfo.columns)}
        print(Compiler.query(tables: tableAndColumns.map{$0.0}, columns: tableAndColumns.map{$0.1}.joined(), join: .natural, limitation: limitation, environment: connection.alias))
    }
}
