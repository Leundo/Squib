//
//  Book.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation
@testable import Squib


struct Book {
    var id: Int
    var title: String
    var author: String?
    var price: Double?
    var page: Int?
    var data: Blob?
}
