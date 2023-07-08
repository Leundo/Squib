//
//  AESEncryptable.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/09.
//

import Foundation
import CryptoKit


@propertyWrapper
public struct AESEncryptable<WrappedValue: DataBindable & Plastic>: Fluctuating, DataBindable {
    public typealias SpecificStorable = Data
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: Data? {
        let storedValue = wrappedValue.storedValue
        switch storedValue {
        case .none:
            return nil
        case .some(let storedValue):
            let sealedBox = try! AES.GCM.seal(storedValue, using: Configuration.aesKey, nonce: Configuration.aesNonce)
            return sealedBox.tag + sealedBox.ciphertext
        }
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> AESEncryptable<WrappedValue> {
        if let storableValue = storableValue as? Data {
            let tag = storableValue[storableValue.startIndex..<storableValue.startIndex + 16]
            let ciphertext = storableValue[storableValue.startIndex + 16..<storableValue.endIndex]
            let sealedBox = try AES.GCM.SealedBox(nonce: Configuration.aesNonce, ciphertext: ciphertext, tag: tag)
            return AESEncryptable<WrappedValue>(wrappedValue: try WrappedValue.from(try AES.GCM.open(sealedBox, using: Configuration.aesKey)))
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension AESEncryptable: Equatable where WrappedValue: Equatable {}
extension AESEncryptable: Hashable where WrappedValue: Hashable {}
