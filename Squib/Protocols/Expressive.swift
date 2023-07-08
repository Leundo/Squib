//
//  Expressive.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public protocol Expressive {
    var incantation: String { get }
}


extension String: Expressive {
    public var incantation: String {
        return self.quote("'")
    }
}


extension Int64: Expressive {
    public var incantation: String {
        return "\(self)"
    }
}


extension Double: Expressive {
    public var incantation: String {
        return "\(self)"
    }
}

extension Blob: Expressive {
    public var incantation: String {
        fatalError("incantation has not been implemented")
    }
}


extension Optional: Expressive where Wrapped: Expressive {
    public var incantation: String {
        if let self = self {
            return self.incantation
        }
        return "NULL"
    }
}


public enum Canister: Expressive {
    case column(payload: Address.Column)
    case value(payload: Expressive)
    
    public var incantation: String {
        switch self {
        case let .value(payload):
            return payload.incantation
        case let .column(payload):
            return payload.incantation
        }
    }
    public func weave(_ environment: String?) -> String {
        switch self {
        case let .value(payload):
            return payload.incantation
        case let .column(payload):
            return payload.weave(environment)
        }
    }
}
