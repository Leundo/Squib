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
    public static func query<Sequence1: Sequence<Address.Table>, Sequence2: Sequence<Address.Column>>(tables: Sequence1, columns: Sequence2, join: Join = .implied, condition: Condition? = nil, limitation: Limitation? = nil, environment: String? = nil) -> String {
        var sql = "SELECT \(Knife.concat(columns.map{$0.weave(environment)}, delimiter: ", ")) FROM \(Knife.concat(tables.map{$0.weave(environment)}, delimiter: join.rawValue))"
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
    public static func replace<Sequence1: Sequence<Address.Column>>(table: Address.Table, columns: Sequence1, environment: String? = nil) -> String {
        return "INSERT OR REPLACE INTO \(table.weave(environment))" + Knife.concat(columns.map{$0.name.quote()}, delimiter: ", ", head: "(", end: ") ") + Knife.concat(columns.map{_ in "?"}, delimiter: ", ", head: "VALUES (", end: ")")
    }
    
    public static func update<Sequence1: Sequence<Address.Column>>(table: Address.Table, columns: Sequence1, condition: Condition, environment: String? = nil) -> String {
        return "UPDATE \(table.weave(environment)) SET " + Knife.concat(columns.map{$0.name.quote() + " = ?"}, delimiter: ", ", end: " ") + condition.weave(environment)
    }
}


// MARK: - Delete
extension Compiler {
    public static func delete(table: Address.Table, condition: Condition, environment: String? = nil) -> String {
        return "DELETE FROM \(table.weave(environment)) " + condition.weave(environment)
    }
}


// MARK: - Misc
extension Compiler {
    public enum Join: String {
        case implied = ", "
        case cross = " CROSS JOIN "
        case natural = " NATURAL JOIN "
        case inner = " INNER JOIN "
        case outer = " OUTER JOIN "
    }
}
