//
//  OverallTest.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/09.
//

import XCTest
@testable import Squib


final class OverallTest: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: FluctuatingTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    lazy var innatePodwer = Powder(connection: innateConnection)
    lazy var acquiredPowder = Powder(connection: acquiredConnection)
    
    override func setUpWithError() throws {
        print(NSHomeDirectory())
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test0() throws {
        var missingPerson = Book(id: 0, title: "暗店街", author: "莫迪亚诺", price: 23.5, page: 400, data: Data([110, 110, 110]))
        let inThePenalColony = Book(id: 0, title: "在流放地", author: "卡夫卡", price: 13.5, page: nil, data: nil)
        
        try acquiredPowder.drop(Book.self)
        try acquiredPowder.create(Book.self)
        try acquiredPowder.replace([missingPerson, inThePenalColony])
        missingPerson.data = nil
        try acquiredPowder.replace(missingPerson)
        
        let queriedBooks = try acquiredPowder.query(Book.self)
        XCTAssert(queriedBooks.contains(where: {$0.title == missingPerson.title}))
        XCTAssert(queriedBooks.contains(inThePenalColony))
        XCTAssert(queriedBooks.contains(missingPerson))
    }
}
