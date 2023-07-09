//
//  Configuration.swift
//  Squib
//
//  Created by Undo Hatsune on 2023/07/08.
//

import Foundation
import CryptoKit


public class Configuration {
    public static var aesKey = SymmetricKey(data: Data(base64Encoded: "X4jvvTKFchnbqL4qjsh0ja6hz8c6jhfsI98ggFkgDts=")!)
    public static var aesNonce = try! AES.GCM.Nonce(data: Data(base64Encoded: "mlbnoFAb8kmaHeOW")!)
    public static var customizedDateFormatter = ISO8601DateFormatter()
}
