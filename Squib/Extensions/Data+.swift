//
//  Data+.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation


extension Data {
    public init(bytes: UnsafeRawPointer, length: Int) {
        let i8bufptr = UnsafeBufferPointer(start: bytes.assumingMemoryBound(to: UInt8.self), count: length)
        self.init([UInt8](i8bufptr))
    }
}
