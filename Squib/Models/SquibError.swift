//
//  SquibError.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public enum SquibError: Error {
    fileprivate static let successCodes: Set = [SQLITE_OK, SQLITE_ROW, SQLITE_DONE]
    
    case sqliteError(message: String, code: Int32)
    case plasticError(storableValue: Storable?)
    
    
    init?(code: Int32, connection: Connection) {
        guard !SquibError.successCodes.contains(code) else { return nil }
        let message = String(cString: sqlite3_errmsg(connection.handle))
        self = SquibError.sqliteError(message: message, code: code)
    }
}
