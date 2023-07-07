//
//  Constant.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


final internal class Constant {
    internal static let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    internal static let dateFormatter = ISO8601DateFormatter()
}
