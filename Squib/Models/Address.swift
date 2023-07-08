//
//  Address.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


public struct Address {
    
}


extension Address {
    public struct Column: Expressive {
        public var name: String
        public var table: Table?
        
        public init(name: String, table: Table? = nil) {
            self.name = name
            self.table = table
        }
        

        public var incantation: String {
            if let table = table {
                return "\(table.incantation).\(name.quote())"
            }
            return name.quote()
        }
        public func weave(_ environment: String?) -> String {
            if let table = table {
                return "\(table.weave(environment)).\(name.quote())"
            }
            return name.quote()
        }
    }
}


extension Address {
    public struct Table: Expressive {
        public var name: String
        public var connection: String?
        
        public init(name: String, connection: String? = nil) {
            self.name = name
            self.connection = connection
        }
        

        public var incantation: String {
            if let connection = connection {
                return "\(connection.quote()).\(name.quote())"
            }
            return name.quote()
        }
        public func weave(_ environment: String?) -> String {
            if let environment = environment, let connection = connection, environment == connection {
                return name.quote()
            }
            return incantation
        }
    }
}
