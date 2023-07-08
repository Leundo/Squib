//
//  Knife.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


final internal class Knife {
    internal static func concat(_ strs: [String], delimiter: String, head: String = "", end: String = "") -> String {
        if strs.count == 0 {
            return head + "" + end
        } else if strs.count == 1 {
            return head + strs[0] + end
        } else {
            return head + strs[1..<strs.count].reduce(strs[0]) {
                initialResult, nextPartialResult in
                return initialResult + delimiter + nextPartialResult
            } + end
        }
    }
    
    internal static func split(_ str: String, delimiter: String, shouldTrim: Bool = true) -> [String] {
        let list = str.components(separatedBy: delimiter)
        if shouldTrim {
            return Array(list.prefix(list.count - 1))
        }
        return list
    }
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
