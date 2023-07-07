//
//  SQLiteTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/07.
//

import XCTest
@testable import Squib


final class SQLiteTests: XCTestCase {
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    let innatePath = Bundle(for: SQLiteTests.self).path(forResource: "innate", ofType: "db")!
    let acquiredPath = NSHomeDirectory() + "/Documents/acquired.db"
    
    lazy var innateDb: OpaquePointer? = {
        var connectedDb: OpaquePointer? = nil
        if sqlite3_open_v2(innatePath, &connectedDb, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
            return connectedDb
        } else {
            return nil
        }
    }()
    
    lazy var acquiredDb: OpaquePointer? = {
        var connectedDb: OpaquePointer? = nil
        if sqlite3_open_v2(acquiredPath, &connectedDb, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
            return connectedDb
        } else {
            return nil
        }
    }()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testConnection() throws {
        XCTAssert(innateDb != nil)
        XCTAssert(acquiredDb != nil)
    }
    
    func testQuerying() throws {
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(innateDb, "SELECT * FROM xctest_book", -1, &queryStatement, nil) ==
            SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                for index in 0..<6 {
                    switch index {
                    case 0:
                        print("Type:\t", sqlite3_column_type(queryStatement, Int32(index)))
                        print(sqlite3_column_int64(queryStatement, Int32(index)))
                    case 1:
                        print("Type:\t", sqlite3_column_type(queryStatement, Int32(index)))
                        print(String(cString: sqlite3_column_text(queryStatement, Int32(index))))
                    case 2:
                        print("Type:\t", sqlite3_column_type(queryStatement, Int32(index)))
                        print(sqlite3_column_double(queryStatement, Int32(index)))
                    case 3:
                        print("Type:\t", sqlite3_column_type(queryStatement, Int32(index)))
                        print(sqlite3_column_int64(queryStatement, Int32(index)))
                    case 4:
                        print("Type:\t", sqlite3_column_type(queryStatement, Int32(index)))
                        print(sqlite3_column_text(queryStatement, Int32(index)))
                    case 5:
                        if sqlite3_column_type(queryStatement, Int32(index)) == 3, let pointer = sqlite3_column_blob(queryStatement, Int32(index)) {
                            let length = Int(sqlite3_column_bytes(queryStatement, Int32(index)))
                            print(Blob(bytes: pointer, length: length))
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func testInserting() throws {
        print(acquiredPath)
        let blob = Blob(bytes: [111, 111, 111])
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(acquiredDb, "INSERT INTO xctest_book(name, price, page, author, data) values(?, ?, ?, ?, ?)", -1, &statement, nil) ==
            SQLITE_OK {
            for columnCount in 0..<2 {
                sqlite3_bind_text(statement, 1, "测试\(columnCount)", -1, SQLITE_TRANSIENT)
                sqlite3_bind_double(statement, 2, 0.1)
                sqlite3_bind_int64(statement, 3, 100)
                sqlite3_bind_null(statement, 4)
                sqlite3_bind_blob(statement, 5, blob.bytes, Int32(blob.bytes.count), SQLITE_TRANSIENT)
                
                print(sqlite3_step(statement))
                sqlite3_reset(statement)
            }
        } else {
            print(sqlite3_prepare_v2(innateDb, "INSERT INTO xctest_book(name, price, page, author, data) values(?, ?, ?, ?, ?)", -1, &statement, nil))
        }
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
