//
//  ColumnableTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import XCTest
@testable import Squib



final class ColumnableTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: SQLiteTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testMirror() throws {
        print(Book.tableInfoDetail)
        for child in Mirror(reflecting: Book.init()).children {
            if let value = child.value as? ColumnableBridge {
                print(value)
            }
        }
    }
    
    func testCreating() throws {
        print(Compiler.create(tableInfo: Book.tableInfo, detail: Book.tableInfoDetail))
    }
}

