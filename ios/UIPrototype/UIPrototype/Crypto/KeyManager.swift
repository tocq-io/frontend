//
//  KeyManager.swift
//  UIPrototype
//
//  Created by Philipp on 21.05.21.
//

import Foundation
import Base58Swift
import LocalAuthentication

struct KeyManager {
    
    private let key: SecKey
    public let publicKey : SecKey
    
    init(name: String){
        key = KeyManager.loadKey(name: name)
        guard let pubKey = SecKeyCopyPublicKey(key) else {
            fatalError("Unresolved error, no public key")
        }
        self.publicKey = pubKey
    }
  
    
    private static func makeAndStoreKey(name: String) -> SecKey?{
        
        let flags: SecAccessControlCreateFlags = Device.hasSecureEnclave ? [.userPresence, .privateKeyUsage] : [.userPresence]
        let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                     kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                     flags,
                                                     nil)!
        let tag = ("io.tocq.pk." + name).data(using: .utf8)!
        var attributes: [String: Any] = [
            kSecAttrKeyType as String           : kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String     : 256,
            kSecPrivateKeyAttrs as String : [
                kSecAttrIsPermanent as String       : true,
                kSecAttrApplicationTag as String    : tag,
                kSecAttrAccessControl as String     : access
            ]
        ]
        
        if Device.hasSecureEnclave {
            attributes[kSecAttrTokenID as String] = kSecAttrTokenIDSecureEnclave
        }
        
        var err: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &err) else {
            fatalError("Can't create: \(err.debugDescription)")
        }
        
        return privateKey
    }
    
    private static func loadKey(name: String) -> SecKey {
        let tag = ("io.tocq.pk." + name).data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String                 : kSecClassKey,
            kSecAttrApplicationTag as String    : tag,
            kSecAttrKeyType as String           : kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String             : true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        switch status {
        case errSecItemNotFound:
            print("new key")
            return makeAndStoreKey(name: name)!
        case errSecSuccess:
            return (item as! SecKey)
        default:
            fatalError("Unresolved error \(status)")
        }
    }
    
    public var pubKeyData: Data {
        var error: Unmanaged<CFError>?
        guard let data = SecKeyCopyExternalRepresentation(publicKey, &error) as NSData? as Data? else {
            fatalError("Can't create: \(error.debugDescription)")
        }
        return data
    }
    
    public static func getB58(signature: Data) -> String {
        let ripmd160Data = RIPEMD160.hash(message: signature)
        
        let encodedString = Base58.base58Encode(Array(ripmd160Data))
        return encodedString
    }
    
    public func sign(text: String) -> Data?{
        let data = text.data(using: .utf8)!
        let noMissingBytes = 32 - data.count
        return self.sign(data: data + Data(repeating: 0, count: noMissingBytes))!
    }
    
    public func sign(data: Data) -> Data?{
        var err: Unmanaged<CFError>?
        let signature = SecKeyCreateSignature(self.key, .ecdsaSignatureDigestX962SHA256,
                                              data as CFData,
                                              &err) as Data?
        guard signature != nil else {
            fatalError("Can't create: \(err.debugDescription)")
        }
        return signature
    }
        
    public func encrypt(text: String) -> Data?{
        let clearTextData = text.data(using: .utf8)!
        var err: Unmanaged<CFError>?
        let cipherTextData = SecKeyCreateEncryptedData(self.publicKey,
                                                       .eciesEncryptionCofactorVariableIVX963SHA256AESGCM,
                                                       clearTextData as CFData,
                                                       &err) as Data?
        guard cipherTextData != nil else {
            fatalError("Can't create: \(err.debugDescription)")
        }
        
        return cipherTextData
    }
    
    
    public func decrypt(cipherTextData: Data) -> String?{
        var err: Unmanaged<CFError>?
        let clearTextData = SecKeyCreateDecryptedData(self.key,
                                                      .eciesEncryptionCofactorVariableIVX963SHA256AESGCM,
                                                      cipherTextData as CFData,
                                                      &err) as Data?
        guard clearTextData != nil else {
            fatalError("Can't create: \(err.debugDescription)")
        }
        return String(decoding: clearTextData!, as: UTF8.self)
    }
        
    public enum Device {
        
        public static var hasTouchID: Bool {
            if #available(OSX 10.12.2, *) {
                return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            } else {
                return false
            }
        }
        
        public static var isSimulator: Bool {
            return TARGET_OS_SIMULATOR != 0
        }
        
        public static var hasSecureEnclave: Bool {
            return hasTouchID && !isSimulator
        }
        
    }
}
