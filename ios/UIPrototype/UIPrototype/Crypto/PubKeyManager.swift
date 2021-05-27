//
//  PubKeyManager.swift
//  UIPrototype
//
//  Created by Philipp on 26.05.21.
//

import Foundation
import Base58Swift

struct PubKeyManager {
    
    public let publicKey : SecKey
    
    init(data: Data){
        self.publicKey = PubKeyManager.loadPubKey(data: data)
    }
    
    private static func loadPubKey(data: Data) -> SecKey {
        let options: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                      kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                      kSecAttrKeySizeInBits as String : 256]
        var error: Unmanaged<CFError>?
        guard let pubKey = SecKeyCreateWithData(data as CFData,
                                             options as CFDictionary,
                                             &error) else {
            fatalError("Can't create: \(error.debugDescription)")
        }
        return pubKey
    }
    
    public var pubKeyData: Data {
        var error: Unmanaged<CFError>?
        guard let data = SecKeyCopyExternalRepresentation(publicKey, &error) as NSData? as Data? else {
            fatalError("Can't create: \(error.debugDescription)")
        }
        return data
    }
    
    public func verify(text: String, signature: Data) -> Bool{
        var data = text.data(using: .utf8)!
      
        let noMissingBytes = 32 - data.count
        data += Data(repeating: 0, count: noMissingBytes)
        
        var error: Unmanaged<CFError>?
        guard SecKeyVerifySignature(self.publicKey, .ecdsaSignatureDigestX962SHA256,
                                    data as CFData,
                                    signature as CFData,
                                    &error) else {
            return false
        }
        return true
    }
}
