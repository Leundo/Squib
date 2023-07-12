//
//  ProtableEntry.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/12.
//

import Foundation
@testable import Squib


struct ProtableEntry {
    @IgnoreHashableColumnable(idColumn, constraint: [.primaryKey, .autoIncrement])
    var id: Int = 0
    
    
    var definition: ProtableDefinition = ProtableDefinition()
    
    init(definition: ProtableDefinition) {
        self.definition = definition
    }
    
    init() {}
}


extension ProtableEntry {
    static let idColumn = "id"
    static let definitionColumn = "definition"
    
    static let tableInfo: TableInfo = TableInfo(name: "protable_entry", connection: "acquired", constraints: [])
}
