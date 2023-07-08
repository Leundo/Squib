//
//  StatementTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import XCTest
@testable import Squib



final class StatementTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: SQLiteTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testAttaching() throws {
        try innateConnection.execute([Compiler.attach(connection: acquiredConnection)])
        let table = Address.Table(name: "book", connection: acquiredConnection.alias)
//        let statement = try Statement(innateConnection, Compiler.query(tables: [table], columns: [Address.Column(name: "id", table: table), Address.Column(name: "title", table: table), Address.Column(name: "data", table: table)], condition: ArrayLikeParallelCondition([Condition.Trio(lhs: .column(payload: Address.Column(name: "id")), rhs: .value(payload: 1), sign: .equal)]), environment: innateConnection.alias))
        let statement = try Statement(innateConnection, Compiler.query(tables: [table], columns: [Address.Column(name: "id", table: table), Address.Column(name: "title", table: table), Address.Column(name: "data", table: table)]))

        print(try statement.retrieve())
    }
    
    func testInserting() throws {
        let statement = try Statement(acquiredConnection, "INSERT INTO book(title, price, page, author, data) values(?, ?, ?, ?, ?)")
        for columnCount in 0..<2 {
            if columnCount == 0 {
                try statement.run("海边的卡夫卡", 23.5, 400, nil, Blob(bytes: [111, 111, 111]))
            } else {
                try statement.run("麦克白", nil, nil, "莎士比亚", nil)
            }
        }
    }
}
