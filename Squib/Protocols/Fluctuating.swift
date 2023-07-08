//
//  Fluctuating.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/07.
//

import Foundation
import CryptoKit


public protocol Fluctuating: Bindable, Plastic, Expressive { }


extension Int: Fluctuating {
    public var storedValue: Int64? { return Int64(self) }
    public var incantation: String { return self.storedValue.incantation }
    public static func from(_ storableValue: (any Storable)?) throws -> Int {
        return Int(try Int64.from(storableValue))
    }
}


extension Bool: Fluctuating {
    public var storedValue: Int64? { return self ? 1 : 0 }
    public var incantation: String { return self.storedValue.incantation }
    public static func from(_ storableValue: (any Storable)?) throws -> Bool {
        return try Int64.from(storableValue) != 0 ? true : false
    }
}


extension Date: Fluctuating {
    public var storedValue: String? { return Constant.dateFormatter.string(from: self) }
    public var incantation: String { return self.storedValue.incantation }
    public static func from(_ storableValue: (any Storable)?) throws -> Date {
        if let storableValue = storableValue as? String, let date = Constant.dateFormatter.date(from: storableValue) {
            return date
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
}


//extension Data: Fluctuating {
//    public var storedValue: Blob? { return Blob.from(self) }
//    public var incantation: String { return self.storedValue.incantation }
//    public static func from(_ storableValue: (any Storable)?) throws -> Data {
//        if let storableValue = storableValue as? Blob {
//            return storableValue.toData()
//        } else {
//            throw SquibError.plasticError(storableValue: storableValue)
//        }
//    }
//}


extension Optional: Fluctuating where Wrapped: Bindable, Wrapped: Plastic, Wrapped: Expressive, Wrapped: Hashable {}


// MARK: - SharpArrayBindable
@propertyWrapper
public struct SharpArrayBindable<Element>: Fluctuating, StringBindable where Element: Fluctuating, Element.SpecificStorable == String {
    public typealias SpecificStorable = Element.SpecificStorable
    public var wrappedValue: Array<Element>
    
    
    public init(wrappedValue value: Array<Element>) {
        self.wrappedValue = value
        if Element.self is ExpressibleByNilLiteral.Type {
            fatalError("optional types can not support")
        }
    }
    
    public var storedValue: Element.SpecificStorable? {
        return wrappedValue.reduce("") { initialResult, nextPartialResult in
            return initialResult + nextPartialResult.storedValue! + "#"
        }
    }

    public static func from(_ storableValue: (any Storable)?) throws -> SharpArrayBindable<Element> {
        if let storableValue = storableValue as? String {
            return SharpArrayBindable<Element>(wrappedValue: try Knife.split(storableValue, delimiter: "#").map {
                return try Element.from($0)
            })
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }

    public var incantation: String {
        return storedValue.incantation
    }

}


extension SharpArrayBindable: Equatable where Element: Equatable {}
extension SharpArrayBindable: Hashable where Element: Hashable {}



// MARK: - JSONSerializationBindable
@propertyWrapper
public struct JSONSerializationBindable<WrappedValue>: Fluctuating, StringBindable {
    public typealias SpecificStorable = String
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: wrappedValue, options: []) else {
            fatalError("JSONSerializationBindable \(String(describing: wrappedValue))")
        }
        guard let result = String(data: data, encoding: String.Encoding.utf8) else {
            fatalError("JSONSerializationBindable \(String(describing: wrappedValue))")
        }
        return result
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> JSONSerializationBindable<WrappedValue> {
        if let storableValue = storableValue as? String, let wrappedValue = try JSONSerialization.jsonObject(with: Data(storableValue.utf8), options: []) as? WrappedValue {
            return JSONSerializationBindable<WrappedValue>(wrappedValue: wrappedValue)
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension JSONSerializationBindable: Equatable where WrappedValue: Equatable {}
extension JSONSerializationBindable: Hashable where WrappedValue: Hashable {}



// MARK: - JSONDecoderBindable
@propertyWrapper
public struct JSONDecoderBindable<WrappedValue: Codable>: Fluctuating, StringBindable {
    public typealias SpecificStorable = String
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: String? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(wrappedValue) else {
            fatalError("JSONDecoderBindable \(String(describing: wrappedValue))")
        }
        guard let result = String(data: data, encoding: String.Encoding.utf8) else {
            fatalError("JSONDecoderBindable \(String(describing: wrappedValue))")
        }
        return result
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> JSONDecoderBindable<WrappedValue> {
        if let storableValue = storableValue as? String, let data = storableValue.data(using: .utf8) {
            let decoder = JSONDecoder()
            return JSONDecoderBindable<WrappedValue>(wrappedValue: try decoder.decode(WrappedValue.self, from: data))
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension JSONDecoderBindable: Equatable where WrappedValue: Equatable {}
extension JSONDecoderBindable: Hashable where WrappedValue: Hashable {}



// MARK: - DataBindable
@propertyWrapper
public struct DataBindable<WrappedValue: Codable>: Fluctuating, BlobBindable {
    public typealias SpecificStorable = Data
    public var wrappedValue: WrappedValue
    
    public init(wrappedValue value: WrappedValue) {
        self.wrappedValue = value
    }
    
    public var storedValue: Data? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(wrappedValue) else {
            fatalError("DataBindable \(String(describing: wrappedValue))")
        }
        return data
    }
    
    public static func from(_ storableValue: (any Storable)?) throws -> DataBindable<WrappedValue> {
        if let storableValue = storableValue as? Data {
            let decoder = JSONDecoder()
            return DataBindable<WrappedValue>(wrappedValue: try decoder.decode(WrappedValue.self, from: storableValue))
        } else {
            throw SquibError.plasticError(storableValue: storableValue)
        }
    }
    
    public var incantation: String {
        return storedValue.incantation
    }
}


extension DataBindable: Equatable where WrappedValue: Equatable {}
extension DataBindable: Hashable where WrappedValue: Hashable {}


// MARK: - AESEncryptable
@propertyWrapper
public struct AESEncryptable<WrappedValue: BlobBindable & Plastic>: Fluctuating, BlobBindable {
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
