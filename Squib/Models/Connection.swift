//
//  Connection.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public final class Connection {
    public var handle: OpaquePointer { return _handle! }
    public var alias: String
    internal var opening: Opening
    fileprivate var _handle: OpaquePointer?
    
    public init(_ opening: Opening, _ alias: String) throws {
        self.opening = opening
        self.alias = alias
        try check(sqlite3_open_v2(opening.description, &_handle, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil))
    }
}


extension Connection {
    public func execute(_ sqls: [String]) throws {
        try sqls.forEach {
            try check(sqlite3_exec(handle, $0, nil, nil, nil))
        }
    }
}


extension Connection {
    public enum Opening: CustomStringConvertible {
        case memory
        case temp
        case path(value: String)
        
        public var description: String {
            switch self {
            case .memory:
                return ":memory:"
            case .temp:
                return ""
            case let .path(value):
                return value
            }
        }
    }
}


extension Connection {
    @discardableResult internal func check(_ code: Int32) throws -> Int32 {
        guard let error = SquibError(code: code, connection: self) else {
            return code
        }
        throw error
    }
}
