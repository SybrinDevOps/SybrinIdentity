//
//  SouthAfricaDriversLicenseParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import MLKitFaceDetection  ////import MLKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common
import Foundation
import MLKitBarcodeScanning


struct SouthAfricaDriversLicenseParser {
    
    // MARK: Internal Methods
//    func ParseFront(from result: Text, success: @escaping (_ model: SouthAfricaDriversLicenseModel) -> Void) {
//        let model = SouthAfricaDriversLicenseModel()
//        
//        let resultText = result.text.lowercased().replaceCommonCharactersWithLetters().replacingOccurrences(of: " ", with: "")
//        guard (resultText.contains("driving") && resultText.contains("license")) || (resultText.contains("bestuurs") && resultText.contains("lisensie")) else { return }
//        
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                if (RegexConstants.SouthAfrica_IdentityNumber.matches(String(line.text.suffix(13)))), let identityNumber = SouthAfricaIdentityNumberParser.ParseIdentityNumber(String(line.text.suffix(13))) {
//                    model.IdentityNumber = identityNumber
//                    success(model)
//                    break outer
//                }
//            }
//        }
//    }
    
    func ParseBack(from result: Barcode, success: @escaping (_ model: SouthAfricaDriversLicenseModel) -> Void) {
        if let barcodeResult = result.rawData {
            if let model = ParseBarcode(barcodeResult) {
                success(model)
            }
        }
    }
    
    // MARK: Private Methods
    private func ParseBarcode(_ barcodeResult: Data) -> SouthAfricaDriversLicenseModel? {
        let model = SouthAfricaDriversLicenseModel()
        let barcodeBytesArray = [UInt8](barcodeResult)
        
        guard barcodeBytesArray.count == 720 else { return nil }
        
        model.BarcodeDataEncrypted = barcodeBytesArray
        
        let bytes = decodeDrivers(bytes: barcodeBytesArray)
        model.BarcodeDataDecrypted = bytes
        
        let section1 = Array(bytes[10..<Int(10 + bytes[5])])
        let section2 = Array(bytes[Int(10 + bytes[5])..<Int(10 + bytes[5] + bytes[7])])
        
        let section1Values = getSection1Values(bytes: section1)
        let section2Values = getSection2Values(bytes: section2)
        
        model.VehicleCodes = Array(section1Values[0..<4])
        model.Surname = section1Values[4]
        model.Initials = section1Values[5]
        model.PRDPCode = section1Values[6]
        model.IDCountryOfIssue = section1Values[7]
        model.LicenseCountryOfIssue = section1Values[8]
        model.VehicleRestrictions = Array(section1Values[9..<13])
        model.LicenseNumber = section1Values[13]
        model.IdentityNumber = SouthAfricaIdentityNumberParser.ParseIdentityNumber(section1Values[14])

        model.IDNumberType = section2Values[0] as? String
        model.IssueDates = (Array(Array(section2Values[1..<5]).filter({ (possibleDate) -> Bool in return (possibleDate as? Date != nil) })) as? [Date])
        model.DriverRestrictions = section2Values[5] as? String
        model.PRDPExpiry = section2Values[6] as? Date
        model.LicenseIssueNumber = section2Values[7] as? String
        model.DateOfBirth = section2Values[8] as? Date
        model.ValidFrom = section2Values[9] as? Date
        model.ValidTo = section2Values[10] as? Date
        model.Sex = ((section2Values[11] as? String == "01") ? .Male : .Female)
        
        return model
    }
    
    private func getSection1Values(bytes: [UInt8]) -> [String] {
        var bytes = bytes
        var values = [String]()
        var prevDeliminator: UInt8 = 0
        
        while (values.count < 14) {
            let index: Int = bytes.firstIndex(where: { (i) -> Bool in i == 224 || i == 225 }) ?? -1
            
            if (prevDeliminator == 225) {
                values.append("")
                
                var value = ""
                Array(bytes[0..<index]).forEach { (charCode) in
                    value += String(UnicodeScalar(charCode))
                }
                if !value.isEmpty {
                    values.append(value)
                }
            }
            else {
                var value = ""
                Array(bytes[0..<index]).forEach { (charCode) in
                    value += String(UnicodeScalar(charCode))
                }
                values.append(value)
            }
            
            prevDeliminator = bytes[index]
            bytes = Array(bytes.suffix(from: index + 1))
        }
        var value = ""
        bytes.forEach { (charCode) in
            value += String(UnicodeScalar(charCode))
        }
        values.append(value)
        
        return values
    }
    
    private func getSection2Values(bytes: [UInt8]) -> [Any?] {
        let hexArr = bytes.map { (byte) -> String in
            var hex = String(byte, radix: 16)
            if hex.count == 1 {
                hex = "0" + hex
            }
            return hex
        }
        
        var nibbleString = ""
        hexArr.forEach { (hex) in
            nibbleString += hex
        }
        
        return getSection2ValuesFromNibbles(nibbleString)
    }
    
    private func getSection2ValuesFromNibbles(_ nibbleString: String) -> [Any?] {
        var nibbleString = nibbleString
        var values = [Any?]()
        
        while (values.count < 12) {
            // If values.length is 0, 5, 7, or 8 - the next values is 2 nibbles (letters) long
            if (values.isEmpty ||
                values.count == 5 ||
                values.count == 7 ||
                values.count == 11) {
                //2 nibbles
                values.append(nibbleString.substring(with: 0..<2))
                nibbleString = nibbleString.substring(from: 2)
                continue
            }

            // If values.length is 0, 5, 7, or 8 - the next values is a date, which can be
            // a single nibble or 8 nibbles long.
            if (values.count == 1 ||
                values.count == 2 ||
                values.count == 3 ||
                values.count == 4 ||
                values.count == 6 ||
                values.count == 8 ||
                values.count == 9 ||
                values.count == 10) {
                if (nibbleString.substring(with: 0..<1) == "a") {
                    // 1 nibble
                    values.append(nil)
                    nibbleString = nibbleString.substring(from: 1)
                } else {
                    // 8 nibbles
                    values.append((nibbleString.substring(with: 0..<8).stringToDate(withFormat: "yyyyMMdd")))
                    nibbleString = nibbleString.substring(from: 8)
                }
                continue
            }
        }
        
        return values
    }
    
    private func decodeDrivers(bytes: [UInt8]) -> [UInt8] {
        let key128 = """
            -----BEGIN RSA PUBLIC KEY-----
            MIGWAoGBAMqfGO9sPz+kxaRh/qVKsZQGul7NdG1gonSS3KPXTjtcHTFfexA4MkGA
            mwKeu9XeTRFgMMxX99WmyaFvNzuxSlCFI/foCkx0TZCFZjpKFHLXryxWrkG1Bl9+
            +gKTvTJ4rWk1RvnxYhm3n/Rxo2NoJM/822Oo7YBZ5rmk8NuJU4HLAhAYcJLaZFTO
            sYU+aRX4RmoF
            -----END RSA PUBLIC KEY-----
            """
        let key74 = """
            -----BEGIN RSA PUBLIC KEY-----
            MF8CSwC0BKDfEdHKz/GhoEjU1XP5U6YsWD10klknVhpteh4rFAQlJq9wtVBUc5Dq
            bsdI0w/bga20kODDahmGtASy9fae9dobZj5ZUJEw5wIQMJz+2XGf4qXiDJu0R2U4
            Kw==
            -----END RSA PUBLIC KEY-----
            """
        var decrypted = [UInt8]()
        
        // 1-5 blocks of 128 bytes and 6th block of 74 bytes
        let block1 = Array(bytes[6..<134])
        let block2 = Array(bytes[134..<262])
        let block3 = Array(bytes[262..<390])
        let block4 = Array(bytes[390..<518])
        let block5 = Array(bytes[518..<646])
        let block6 = Array(bytes[646..<720])
        
        // decode first 5 blocks and add to decrypted.
        if let startIndex = key128.indexUpper(of: "-----BEGIN RSA PUBLIC KEY-----"), let endIndex = key128.indexLower(of: "-----END RSA PUBLIC KEY-----") {
            let certText = key128.substring(from: startIndex, to: endIndex).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
            let _ = Data(base64Encoded: certText, options: [])! //certBytes
            
            // This is a hacked way, replace the below modulus and exponent to the correct values. Use ASN.1 parser with BER encoding rules, then generate the sequence. The first element in the sequence is the modulus and second element in the sequence is the exponent.
            let modulus: BigUInt = "142285637969500137591568888956585993000804975117790396232777086170478419318132913522586477354726719429490064026067014210429619685608314997328427121338761342599213353211229073303585007424804057533100582962564829105750677753599911411738292064374365191718771831295972974064055193787765648355784736817555153584587"
            let exponent: BigUInt = "32485987681586469730746811642209004037"
            
            decrypted += Array(encryptValue(val: block1, e: exponent, n: modulus).suffix(from: 5))
            decrypted += Array(encryptValue(val: block2, e: exponent, n: modulus).suffix(from: 5))
            decrypted += Array(encryptValue(val: block3, e: exponent, n: modulus).suffix(from: 5))
            decrypted += Array(encryptValue(val: block4, e: exponent, n: modulus).suffix(from: 5))
            decrypted += Array(encryptValue(val: block5, e: exponent, n: modulus).suffix(from: 5))
        } else {
            "Failed to get certificate starting and ending indices".log(.ProtectedError)
            return [UInt8]()
        }
        
        // decode last block of 74 and add to decrypted.
        if let startIndex = key74.indexUpper(of: "-----BEGIN RSA PUBLIC KEY-----"), let endIndex = key74.indexLower(of: "-----END RSA PUBLIC KEY-----") {
            let certText = key74.substring(from: startIndex, to: endIndex).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
            let _ = Data(base64Encoded: certText, options: [])! //certBytes
            
            // This is a hacked way, replace the below modulus and exponent to the correct values. Use ASN.1 parser with BER encoding rules, then generate the sequence. The first element in the sequence is the modulus and second element in the sequence is the exponent.
            let modulus: BigUInt = "11398129644843786581386553841004179888998193437828394603842446728081939277966586183550370603851607383765263271700106449597200279677345725440061667628191472959172992275515421307111"
            let exponent: BigUInt = "64618111067323083759039621379138074667"
            
            decrypted += encryptValue(val: block6, e: exponent, n: modulus)
        }
        else {
            "Failed to get certificate starting and ending indices".log(.ProtectedError)
        }
        
        return decrypted
    }
    
    private func encryptValue(val: [UInt8], e: BigUInt, n: BigUInt) -> [UInt8] {
        let input = decodeBigUInt(val)
        let output = input.power(e, modulus: n)
        return encodeBigUInt(output)
    }
    
    private func decodeBigUInt(_ bytes: [UInt8]) -> BigUInt {
        var result = BigUInt("0")
        for i in 0..<bytes.count {
            result += BigUInt(bytes[bytes.count - i - 1]) << (8 * i)
        }
        return result
    }
    
    private func encodeBigUInt(_ number: BigUInt) -> [UInt8] {
        var number = number
        let byteMask = BigUInt(0xff)
        let size = (number.bitWidth + 7) >> 3
        var result = [UInt8](repeating: 0, count: size)
        for i in 0..<size {
            result[size - i - 1] = UInt8(number & byteMask)
            number = number >> 8
        }
        return result
    }
    
}
