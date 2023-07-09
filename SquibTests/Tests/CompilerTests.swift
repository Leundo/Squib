//
//  CompilerTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import XCTest
@testable import Squib



final class CompilerTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: CompilerTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    override func setUpWithError() throws {
        print(NSHomeDirectory())
    }

    override func tearDownWithError() throws {
    }
    
    func testInsertingAndQuerying() throws {
        let missingPerson = Book(id: 0, title: "暗店街", author: "莫迪亚诺", price: 23.5, page: 400, data: Data([110, 110, 110]))
        let inThePenalColony = Book(id: 0, title: "在流放地", author: "卡夫卡", price: 13.5, page: 200, data: Data([111, 111, 111]))

        
        try Statement(acquiredConnection, Compiler.drop(table: Book.tableInfo.table)).run()
        try Statement(acquiredConnection, Compiler.create(detailTableInfo: Book.detailTableInfo)).run()

        let replacing = try Statement(acquiredConnection, Compiler.replace(table: Book.detailTableInfo.table, columns: Book.columnDictionary[.notPrimary]!, environment: acquiredConnection.alias))
        try replacing.run(missingPerson.getReflectedValues(Book.columnDictionary[.notPrimary]!))
        let replacing2 = try Statement(acquiredConnection, Compiler.replace(table: Book.detailTableInfo.table, columns: Book.columnDictionary[.notPrimary]!, environment: acquiredConnection.alias))
        try replacing2.run(inThePenalColony.getReflectedValues(Book.columnDictionary[.notPrimary]!))
        let querying = try Statement(acquiredConnection, Compiler.query(tables: [Book.detailTableInfo.table], columns: Book.columnDictionary[.notPrimary]!, environment: acquiredConnection.alias))
        
        let retrievedBook = try Array<Book>.from(try querying.retrieve(), Book.columnDictionary[.notPrimary]!)[0]
        XCTAssert(retrievedBook == missingPerson)
    }
}
