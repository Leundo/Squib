//
//  Statement.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public final class Statement {
    fileprivate var handle: OpaquePointer?
    fileprivate let connection: Connection
    
    internal init(_ connection: Connection, _ sql: String) throws {
        self.connection = connection
        try connection.check(sqlite3_prepare_v2(connection.handle, sql, -1, &handle, nil))
    }
    
    deinit {
        sqlite3_finalize(handle)
    }
    
    internal lazy var columnCount: Int = Int(sqlite3_column_count(handle))
    internal lazy var columnNames: [String] = (0..<Int32(columnCount)).map {
        String(cString: sqlite3_column_name(handle, $0))
    }
}


// MARK: - Bind
extension Statement {
    public func bind(_ values: (any Bindable)?...) -> Statement {
        bind(values)
    }
    
    public func bind(_ values: [(any Bindable)?]) -> Statement {
        reset()
        if values.isEmpty { return self }
        guard values.count == Int(sqlite3_bind_parameter_count(handle)) else {
            fatalError("\(sqlite3_bind_parameter_count(handle)) values expected, \(values.count) passed")
        }
        for index in 1...values.count { bind(values[index - 1], at: index) }
        return self
    }
    
    public func bind(_ values: [String: (any Bindable)?]) -> Statement {
        reset()
        for (name, value) in values {
            let index = sqlite3_bind_parameter_index(handle, name)
            guard index > 0 else {
                fatalError("parameter not found: \(name)")
            }
            bind(value, at: Int(index))
        }
        return self
    }
    
    fileprivate func bind(_ value: (any Bindable)?, at index: Int) {
        let value = value?.storedValue
        switch value {
        case .none:
            sqlite3_bind_null(handle, Int32(index))
        case let value as Blob where value.bytes.count == 0:
            sqlite3_bind_zeroblob(handle, Int32(index), 0)
        case let value as Blob:
            sqlite3_bind_blob(handle, Int32(index), value.bytes, Int32(value.bytes.count), Constant.SQLITE_TRANSIENT)
        case let value as Double:
            sqlite3_bind_double(handle, Int32(index), value)
        case let value as Int64:
            sqlite3_bind_int64(handle, Int32(index), value)
        case let value as String:
            sqlite3_bind_text(handle, Int32(index), value, -1, Constant.SQLITE_TRANSIENT)
        case .some(let value):
            fatalError("tried to bind unexpected value \(value)")
        }
    }
}


// MARK: - Reset
extension Statement {
    public func reset() {
        reset(clearBindables: true)
    }
    
    fileprivate func reset(clearBindables shouldClear: Bool) {
        sqlite3_reset(handle)
        if shouldClear { sqlite3_clear_bindings(handle) }
    }
}


// MARK: - Step & Run
extension Statement {
    public func step() throws -> Bool {
        return try connection.check(sqlite3_step(handle)) == SQLITE_ROW
    }
    
    @discardableResult public func run(_ values: (any Bindable)?...) throws -> Statement {
        guard values.isEmpty else {
            return try run(values)
        }

        reset(clearBindables: false)
        repeat {} while try step()
        return self
    }
    
    @discardableResult public func run(_ values: [String: (any Bindable)?]) throws -> Statement {
        try bind(values).run()
    }
    
    @discardableResult public func run(_ values: [(any Bindable)?]) throws -> Statement {
        try bind(values).run()
    }
    
    public func retrieve(_ values: (any Bindable)?...) throws -> [[(any Storable)?]] {
        guard values.isEmpty else {
            return try retrieve(values)
        }
        
        reset(clearBindables: false)
        var results: [[(any Storable)?]] = []
        while try step() {
            results.append(Array<(any Storable)?>(Cursor(self)))
        }
        return results
    }
    
    public func retrieve(_ values: [(any Bindable)?]) throws -> [[(any Storable)?]] {
        return try bind(values).retrieve()
    }
    
    public func retrieve(_ values: [String: (any Bindable)?]) throws -> [[(any Storable)?]] {
        return try bind(values).retrieve()
    }
    
    public func extract(_ values: (any Bindable)?...) throws -> (any Storable)? {
        guard values.isEmpty else {
            return try extract(values)
        }
        
        reset(clearBindables: false)
        _ = try step()
        return Cursor(self)[0]
    }
    
    public func extract(_ values: [(any Bindable)?]) throws -> (any Storable)? {
        return try bind(values).extract()
    }
    
    public func extract(_ values: [String: (any Bindable)?]) throws -> (any Storable)? {
        return try bind(values).extract()
    }
}



internal struct Cursor {
    fileprivate let handle: OpaquePointer
    fileprivate let columnCount: Int
    
    fileprivate init(_ statement: Statement) {
        handle = statement.handle!
        columnCount = statement.columnCount
    }
    
    public subscript(index: Int) -> (any Storable)? {
        let type = Datatype.init(rawValue: Int(sqlite3_column_type(handle, Int32(index))))!
        switch type {
        case .null:
            return nil
        case .interger:
            return sqlite3_column_int64(handle, Int32(index))
        case .real:
            return sqlite3_column_double(handle, Int32(index))
        case .text:
            return String(cString: UnsafePointer(sqlite3_column_text(handle, Int32(index))))
        case .blob:
            if let pointer = sqlite3_column_blob(handle, Int32(index)) {
                let length = Int(sqlite3_column_bytes(handle, Int32(index)))
                return Blob(bytes: pointer, length: length)
            } else {
                // The return value from sqlite3_column_blob() for a zero-length BLOB is a NULL pointer.
                // https://www.sqlite.org/c3ref/column_blob.html
                return Blob(bytes: [])
            }
        }
    }
}


extension Cursor: Sequence {
    internal func makeIterator() -> AnyIterator<(any Storable)?> {
        var index = 0
        return AnyIterator {
            if index >= columnCount {
                return .none
            } else {
                index += 1
                return self[index - 1]
            }
        }
    }
}
