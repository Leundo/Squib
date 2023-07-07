//
//  String+.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


extension String {
    internal func quote(_ mark: Character = "\"") -> String {
        var quoted = ""
        quoted.append(mark)
        for character in self {
            quoted.append(character)
            if character == mark {
                quoted.append(character)
            }
        }
        quoted.append(mark)
        return quoted
    }
}
