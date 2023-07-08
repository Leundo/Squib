////
////  Proton.swift
////  Squib
////
////  Created by Undo Hatsune on 2023/07/07.
////
//
//import Foundation
//
//
//internal struct Proton {
//    internal var name: String
//    internal var storage: (any Bindable)?
//    internal var type: Datatype
//    
//    internal init(name: String, storage: (any Bindable)?, type: Datatype) {
//        self.name = name
//        self.storage = storage
//        self.type = type
//    }
//}
//
//
//internal enum Datatype: Int, Hashable {
//    case interger = 1
//    case real = 2
//    case text = 3
//    case blob = 4
//    case null = 5
//    
//    internal var swiftType: Any.Type? {
//        switch self {
//        case .interger:
//            return Int64.self
//        case .real:
//            return Double.self
//        case .text:
//            return String.self
//        case .blob:
//            return Blob.self
//        case .null:
//            return nil
//        }
//    }
//}
//
//
//extension Datatype: CustomStringConvertible {
//    internal var description: String {
//        switch self {
//        case .interger:
//            return "INTEGER"
//        case .real:
//            return "REAL"
//        case .text:
//            return "TEXT"
//        case .blob:
//            return "BLOB"
//        case .null:
//            return "NULL"
//        }
//    }
//}
