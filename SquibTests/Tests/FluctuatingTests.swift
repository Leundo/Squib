//
//  FluctuatingTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/08.
//

import XCTest
@testable import Squib



final class FluctuatingTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: SQLiteTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    override func setUpWithError() throws {
        print(NSHomeDirectory())
    }

    override func tearDownWithError() throws {
    }
    
    func testSharpArray() throws {
        var foo = Foo()
        foo.dates = [Date(timeIntervalSince1970: 0), Date(timeIntervalSince1970: 4096)]
        foo.times = [Date(timeIntervalSince1970: 20000), Date(timeIntervalSince1970: 40000)]
        foo.papers = ["AAA", "BBB"]
        foo.clocks = [Date(timeIntervalSince1970: 80000), Date(timeIntervalSince1970: 160000)]
        
        try Statement(acquiredConnection, Compiler.drop(table: Foo.tableInfo.table)).run()
        try Statement(acquiredConnection, Compiler.create(detailTableInfo: Foo.detailTableInfo)).run()
        let replacing = try Statement(acquiredConnection, Compiler.replace(table: Foo.detailTableInfo.table, columns: Foo.columnDictionary[.notPrimary]!, environment: acquiredConnection.alias))
        try replacing.run(foo.getReflectedValues(Foo.columnDictionary[.notPrimary]!))
        let querying = try Statement(acquiredConnection, Compiler.query(tables: [Foo.detailTableInfo.table], columns: Foo.columnDictionary[.notPrimary]!, environment: acquiredConnection.alias))
        
        let retrievedFoo = try Array<Foo>.from(try querying.retrieve(), Foo.columnDictionary[.notPrimary]!)[0]
        XCTAssert(retrievedFoo == foo)
    }
}


fileprivate struct Foo: Hashable, Tableable, Reflectable, Rebuildable {
    @Columnable("id", constraint: [.primaryKey, .autoIncrement])
    var id: Int = 0
    @Columnable("dates")
    @SharpArrayBindable
    var dates: [Date] = []
    @Columnable("papers")
    @JSONSerializationBindable
    var papers: [String] = []
    @Columnable("times")
    @JSONDecoderBindable
    var times: [Date] = []
    @Columnable("clocks")
    @DataBindable
    var clocks: [Date] = []
    
    init() {}
    static let tableInfo: TableInfo = TableInfo(name: "foo", connection: "acquired", constraints: [])
}
