//
//  Knife.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


final internal class Knife {
    
}



extension Knife {
    internal enum Log: Hashable {
        case warning
        case error
        case info
    }
    
    internal static func log(_ str: String, type: Log) {
        var prefix: String
        switch type {
        case .warning:
            prefix = "\n[Warning]:\t"
        case .error:
            prefix = "\n[Error]:\t"
        case .info:
            prefix = "\n[Info]:\t"
        }
        print("\(prefix)\(str)\n")
    }
}
