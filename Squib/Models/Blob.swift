//
//  Blob.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation


public struct Blob: Hashable {
    public let bytes: [UInt8]
    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    public init(bytes: UnsafeRawPointer, length: Int) {
        let i8bufptr = UnsafeBufferPointer(start: bytes.assumingMemoryBound(to: UInt8.self), count: length)
        self.init(bytes: [UInt8](i8bufptr))
    }
}
