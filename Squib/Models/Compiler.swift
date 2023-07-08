//
//  Compiler.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public class Compiler {
    public static func begin() -> String { return "BEGIN" }
    public static func commit() -> String { return "COMMIT" }
    
    public static func attach(opening: Connection.Opening, alias: String) -> String {
        return "ATTACH DATABASE \(opening.description.quote("'")) AS \(alias.quote())"
    }
    public static func attach(connection: Connection) -> String {
        return attach(opening: connection.opening, alias: connection.alias)
    }
}


extension Compiler {
    public static func create(tableInfo: TableInfo, detail: TableInfo.Detail) -> String {
        return Knife.concat(detail.columnDescriptions.map {"\($0.name.quote()) \($0.type.description) \($0.constrain.incantation)"} + tableInfo.constraints.map { $0.incantation },delimiter: ", ", head: "CREATE TABLE IF NOT EXISTS \(tableInfo.name.quote()) (", end: ")")
    }
}

extension Compiler {    
    public static func query(tables: [Address.Table], columns: [Address.Column], condition: Condition? = nil, limitation: Limitation? = nil, environment: String? = nil) -> String {
        var sql = "SELECT \(Knife.concat(columns.map{$0.weave(environment)}, delimiter: ", ")) FROM \(Knife.concat(tables.map{$0.weave(environment)}, delimiter: ", "))"
        if let condition = condition {
            sql = sql + " " + condition.weave(environment)
        }
        if let limitation = limitation {
            sql = sql + " " + limitation.incantation
        }
        return sql
    }
}
