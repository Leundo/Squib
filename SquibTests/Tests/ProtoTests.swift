//
//  ProtoTests.swift
//  SquibTests
//
//  Created by Undo Hatsune on 2023/07/12.
//

import XCTest
@testable import Squib


final class ProtoTests: XCTestCase {
    lazy var innateConnection = try! Connection(.path(value: Bundle(for: ProtoTests.self).path(forResource: "innate", ofType: "db")!), "innate")
    lazy var acquiredConnection = try! Connection(.path(value: NSHomeDirectory() + "/Documents/acquired.db"), "acquired")
    
    lazy var innatePodwer = Powder(connection: innateConnection)
    lazy var acquiredPowder = Powder(connection: acquiredConnection)
    
    override func setUpWithError() throws {
        print(NSHomeDirectory())
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testProtableDefinition() throws {
        let definition = ProtableDefinition.with {
            $0.hinshiSet = 24334
        }
        
        let binaryData: Data = try definition.serializedData()
        print(binaryData)
        print(binaryData.count)
        
    }
}
