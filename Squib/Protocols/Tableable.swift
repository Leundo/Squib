//
//  Tableable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public protocol Tableable: Phantom {
    static var tableInfo: TableInfo { get }
}


extension Tableable {
    public static var detailTableInfo: DetailTableInfo {
        return Storehouse.shared.getItem(Self.self, "Tableable-detailTableInfo") {
            return DetailTableInfo(tableInfo: tableInfo, columnDescriptions: Mirror(reflecting: Self.phantom).children.compactMap{
                return $0.value as? ColumnableBridge
            }.map { value in
                if MetatypeManager.int64BindableTypes.contains(where: {value.valueType == $0 }) {
                    return ColumnDescription(value.name, Datatype.interger, value.constraint)
                } else if MetatypeManager.doubleBindableTypes.contains(where: {value.valueType == $0 }) {
                    return ColumnDescription(value.name, Datatype.real, value.constraint)
                } else if MetatypeManager.stringBindableTypes.contains(where: {value.valueType == $0 }) {
                    return ColumnDescription(value.name, Datatype.text, value.constraint)
                } else if MetatypeManager.blobBindableTypes.contains(where: {value.valueType == $0 }) {
                    return ColumnDescription(value.name, Datatype.blob, value.constraint)
                }
                fatalError("could not process \(value.valueType)")
            })
        }
    }
    
    public static var conditionDictionary: [UInt: Condition] {
        get {
            return Storehouse.shared.getItem(Self.self, "Tableable-conditionDictionary") {
                return [:]
            }
        }
        set {
            Storehouse.shared.setItem(Self.self, "Tableable-conditionDictionary", item: newValue)
        }
    }
    
    public static var columnDictionary: [ColumnKey: [Address.Column]] {
        get {
            let allColumns = detailTableInfo.columnDescriptions.map{$0.name}
            let primaryColumns = Array(Set(detailTableInfo.columnDescriptions.filter {
                return $0.constrain.contains(.primaryKey)
            }.map{
                return $0.name
            } + detailTableInfo.constraints.compactMap {
                if case let .primaryKey(names, _) = $0 {
                    return names
                }
                return nil
            }.joined()))
            let tableUniqueColumns = Array(detailTableInfo.constraints.compactMap {
                if case let .unique(names) = $0 {
                    return names
                }
                return nil
            }.joined())
            return Storehouse.shared.getItem(Self.self, "Tableable-columnDictionary") {
                return [
                    .primary: detailTableInfo.getColumnAddresses(primaryColumns),
                    .notPrimary: detailTableInfo.getColumnAddresses(allColumns.filter{!primaryColumns.contains($0)}),
                    .tableUnique: detailTableInfo.getColumnAddresses(tableUniqueColumns),
                    .notTableUnique: detailTableInfo.getColumnAddresses(allColumns.filter{!tableUniqueColumns.contains($0)}),
                ]
            }
        }
        set {
            Storehouse.shared.setItem(Self.self, "Tableable-columnDictionary", item: newValue)
        }
    }
}


//MARL: - Key
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


// MARK: - TableInfo
public class TableInfo {
    public let name: String
    public let connection: String?
    public let constraints: [Constraint.Table]
    
    public private(set) lazy var table: Address.Table = { return Address.Table(name: name, connection: connection)}()
    
    public init(name: String, connection: String?, constraints: [Constraint.Table]) {
        self.name = name
        self.connection = connection
        self.constraints = constraints
    }
}


public class DetailTableInfo: TableInfo {
    public let columnDescriptions: [ColumnDescription]
    public private(set) lazy var columns: [Address.Column] = {
        return columnDescriptions.map {Address.Column(name: $0.name, table: table)}
    }()
        
    public init(tableInfo: TableInfo, columnDescriptions: [ColumnDescription]) {
        self.columnDescriptions = columnDescriptions
        super.init(name: tableInfo.name, connection: tableInfo.connection, constraints: tableInfo.constraints)
    }
    
    public func getColumnAddresses(_ names: [String]) -> [Address.Column] {
        return columns.filter { names.contains($0.name) }
    }
}


// MARK: - ColumnDescription
public struct ColumnDescription {
    public var name: String
    public var type: Datatype
    public var constrain: Constraint.Column
    
    public init(_ name: String, _ type: Datatype, _ constrain: Constraint.Column) {
        self.name = name
        self.type = type
        self.constrain = constrain
    }
}


// MARK: - Datatype
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
