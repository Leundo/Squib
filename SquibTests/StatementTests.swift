//
//  StatementTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/07.
//

import XCTest
@testable import Squib


final class StatementTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: SQLiteTests.self).path(forResource: "innate", ofType: "db")!))
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"))
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testQuerying() throws {
        let statement = try Statement(innateConnection, "SELECT * FROM xctest_book")
        print(try statement.retrieve())
        print(try statement.extract())
    }
    
    func testInserting() throws {
        let statement = try Statement(acquiredConnection, "INSERT INTO xctest_book(name, price, page, author, data) values(?, ?, ?, ?, ?)")
        for columnCount in 0..<2 {
            try statement.run("StatementTests\(columnCount)", 0.1, 100, nil, Blob(bytes: [112, 112, 112]))
        }
    }
}
