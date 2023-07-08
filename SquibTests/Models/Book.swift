//
//  Book.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation
@testable import Squib


struct Book {
    @Columnable(idColumn, constraint: [.primaryKey, .autoIncrement])
    var id: Int = 0
    @Columnable(titleColumn, constraint: [.notNull])
    var title: String = ""
//    @Columnable(authorColumn)
    var author: String? = nil
    var price: Double? = nil
    var page: Int? = nil
    var data: Blob? = nil
}


extension Book {
    static let idColumn = "id"
    static let titleColumn = "title"
    static let authorColumn = "author"
    static let priceColumn = "price"
    static let pageColumn = "page"
    static let dataColumn = "data"
}
