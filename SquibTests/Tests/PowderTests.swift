//
//  PowderTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/09.
//

import XCTest
@testable import Squib



final class PowderTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: FluctuatingTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    lazy var innatePodwer = Powder(connection: innateConnection)
    lazy var acquiredPowder = Powder(connection: acquiredConnection)
    
    override func setUpWithError() throws {
        print(NSHomeDirectory())
    }

    override func tearDownWithError() throws {
    }
    
    func testPerformanceExample() throws {
        self.measure {
        }
    }
    
    func testExecuting() throws {
        try acquiredPowder.execute("DROP TABLE foo")
    }
    
    func testNaturallyQuerying() throws {
        try acquiredPowder.naturallyQuery(Foo.self, [Foo.self, Book.self])
    }
}


fileprivate struct Foo: Hashable, Explosive {
    @Columnable("id", constraint: [.primaryKey, .autoIncrement])
    var id: Int = 0
    @Columnable("dates")
    @SharpArrayCharacterizable
    var dates: [Date] = []
    @Columnable("optionalDates")
    @OptionalSharpArrayCharacterizable
    var optionalDates: [Date]? = []
    @Columnable("papers")
    @JSONSerializable
    var papers: [String] = []
    @Columnable("times")
    @JSONUtfCodable
    var times: [Date] = []
    @Columnable("clocks")
    @AESEncryptable
    @JSONDataCodable
    var clocks: [Date]? = []
    
    init() {}
    static let tableInfo: TableInfo = TableInfo(name: "foo", connection: "acquired", constraints: [])
}
