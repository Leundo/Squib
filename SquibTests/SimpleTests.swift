//
//  SimpleTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/07.
//

import XCTest
@testable import Squib


final class SimpleTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: SQLiteTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testQuerying0() throws {
        let statement = try Statement(innateConnection, "SELECT * FROM xctest_book")
        print(try statement.retrieve())
        print(try statement.extract())
    }
    
    func testQuerying1() throws {
//        let statement0 = try Statement(innateConnection, Compiler.query(table: "xctest_book", columns: ["id", "name", "data"], condition: ArrayLikeParallelCondition([Condition.Trio(lhs: .column(payload: Address.Column(name: "id")), rhs: .value(payload: 1), sign: .equal)])))
        let table = Address.Table(name: "xctest_book")
        let statement1 = try Statement(innateConnection, Compiler.query(tables: [table], columns: [Address.Column(name: "id", table: table), Address.Column(name: "name", table: table), Address.Column(name: "data", table: table)], condition: ArrayLikeParallelCondition([Condition.Trio(lhs: .column(payload: Address.Column(name: "id")), rhs: .value(payload: 1), sign: .equal)])))
//        print(try statement0.retrieve())
        print(try statement1.retrieve())
    }
    
    func testInserting() throws {
        let statement = try Statement(acquiredConnection, "INSERT INTO xctest_book(name, price, page, author, data) values(?, ?, ?, ?, ?)")
        for columnCount in 0..<2 {
            try statement.run("StatementTests\(columnCount)", 0.1, 100, nil, Data([112, 112, 112]))
        }
    }
}
