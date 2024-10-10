//
//  AES.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/10/20.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import CommonCrypto
import Foundation

struct AES {
    
    // MARK: Private Properties
    private var Key: Data = Data()
    private var InitialVector: Data = Data()
    
    // MARK: Initializers
    init(appID: String? = Bundle.main.bundleIdentifier) {
        let securityKey = self.CreateSecurityKey(self.RemoveSpecialCharacters(String(appID ?? "")));
        
        let key = securityKey
        let initialVector = securityKey
        
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            "Failed to set a key".log(.ProtectedError)
            return
        }
        
        guard initialVector.count == kCCBlockSizeAES128, let initialVectorData = initialVector.data(using: .utf8) else {
           "Failed to set an initial vector".log(.ProtectedError)
            return
        }
        
        self.Key = keyData
        self.InitialVector  = initialVectorData
    }
    
    // MARK: Internal Methods
    func Encrypt(string: String) -> Data? {
        return Crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    func Decrypt(message: String) -> String? {
        let data = Data(base64Encoded: message)
        
        guard let decryptedData = Crypt(data: data, option: CCOperation(kCCDecrypt)) else {
            "Failed to decrypt key".log(.ProtectedError)
            return nil
        }
        
        let result = String(bytes: decryptedData, encoding: .utf8)
        
        return result
    }
    
    func Decrypt(data: Data?) -> String? {
        guard let decryptedData = Crypt(data: data, option: CCOperation(kCCDecrypt)) else {
            "Failed to decrypt key".log(.ProtectedError)
            return nil
        }
        
        let result = String(bytes: decryptedData, encoding: .utf8)
        
        return result
    }
    
    // MARK: Private Methods
    private func Crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = Key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                InitialVector.withUnsafeBytes { ivBytes in
                    Key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            "Failed to crypt data".log(.ProtectedError)
            "Status: \(status)".log(.Verbose)
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        
        return cryptData
    }
    
    private func CreateSecurityKey(_ appID: String) -> String {
        let initialKey = "IOS"
        var initialKey2 = ""
        var finalKey = ""
        
        if (appID.count == 13) {
            initialKey2 = appID
            finalKey = initialKey + initialKey2
        } else if (appID.count > 13) {
            initialKey2 = String(String(appID).prefix(13))
            finalKey = initialKey + initialKey2
        } else if (appID.count < 13) {
            initialKey2 = appID;
            finalKey = initialKey + initialKey2
            
            let paddingLenght = 16 - finalKey.count
            
            for _ in stride(from: 0, to: paddingLenght, by: 1) {
                finalKey += "X";
            }
        }
        
        return finalKey
    }
    
    private func RemoveSpecialCharacters(_ apiString: String) -> String {
        let okayChars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        let filteredString = String(apiString.filter {okayChars.contains($0) })
        
        return filteredString
    }
    
}

