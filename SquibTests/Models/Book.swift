//
//  Book.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation
@testable import Squib


struct Book: Tableable {
    @Columnable(idColumn, constraint: [.primaryKey, .autoIncrement])
    var id: Int = 0
    @Columnable(titleColumn, constraint: [.notNull])
    var title: String = ""
    @Columnable(authorColumn)
    var author: String? = nil
    @Columnable(priceColumn)
    var price: Double? = nil
    @Columnable(pageColumn)
    var page: Int? = nil
    @Columnable(dataColumn)
    var data: Blob? = nil
    
    init() {}
    
    static let tableInfo: TableInfo = TableInfo(name: "book", connection: "innate", constraints: [.unique(names: [titleColumn, authorColumn])])
}


extension Book {
    static let idColumn = "id"
    static let titleColumn = "title"
    static let authorColumn = "author"
    static let priceColumn = "price"
    static let pageColumn = "page"
    static let dataColumn = "data"
}
