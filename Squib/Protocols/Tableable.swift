//
//  Tableable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public protocol Tableable {
    var tableInfo: TableInfo { get }
}


public struct TableInfo {
    var name: String
    var connection: String?
    var constraint: [Constraint.Table]
}
