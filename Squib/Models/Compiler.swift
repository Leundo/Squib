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


// MARK: - Create & Drop
extension Compiler {
    public static func create(detailTableInfo: DetailTableInfo) -> String {
        return Knife.concat(detailTableInfo.columnDescriptions.map {"\($0.name.quote()) \($0.type.description) \($0.constrain.incantation)"} + detailTableInfo.constraints.map { $0.incantation },delimiter: ", ", head: "CREATE TABLE IF NOT EXISTS \(detailTableInfo.name.quote()) (", end: ")")
    }
    
    public static func drop(table: Address.Table) -> String {
        return "DROP TABLE IF EXISTS \(table.name.quote())"
    }
}


// MARK: - Query
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


// MARK: - Replace & Update
extension Compiler {
    public static func replace(table: Address.Table, columns: [Address.Column], environment: String? = nil) -> String {
        return "INSERT OR REPLACE INTO \(table.weave(environment))" + Knife.concat(columns.map{$0.name.quote()}, delimiter: ", ", head: "(", end: ") ") + Knife.concat(columns.map{_ in "?"}, delimiter: ", ", head: "VALUES (", end: ")")
    }
    
    public static func update(table: Address.Table, columns: [Address.Column], condition: Condition, environment: String? = nil) -> String {
        return "UPDATE \(table.weave(environment)) SET " + Knife.concat(columns.map{$0.name.quote() + " = ?"}, delimiter: ", ", end: " ") + condition.weave(environment)
    }
}


// MARK: - Delete
extension Compiler {
    public static func delete(table: Address.Table, condition: Condition, environment: String? = nil) -> String {
        return "DELETE FROM \(table.weave(environment)) " + condition.weave(environment)
    }
}
