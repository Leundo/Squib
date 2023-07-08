//
//  Book.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation
@testable import Squib


struct Book: Tableable, Reflectable, Rebuildable, Hashable {
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
    var data: Data? = nil
    
    init() {}
    
    init(id: Int, title: String, author: String?, price: Double?, page: Int?, data: Data?) {
        self.id = id
        self.title = title
        self.author = author
        self.price = price
        self.page = page
        self.data = data
    }
    
    static let tableInfo: TableInfo = TableInfo(name: "book", connection: "acquired", constraints: [.unique(names: [titleColumn, authorColumn])])
}


extension Book {
    static let idColumn = "id"
    static let titleColumn = "title"
    static let authorColumn = "author"
    static let priceColumn = "price"
    static let pageColumn = "page"
    static let dataColumn = "data"
}
