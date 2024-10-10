//
//  PhilippinesPassportParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin.IOS.Common
import MLKitBarcodeScanning
import Foundation
import MLKitVision 
import MLKitFaceDetection 

struct PhilippinesPassportParser {
    
    // MARK: Private Properties
    // Parser
    private let Parser = TraditionalTD3Parser(issuingCountryCode: Country.Philippines.passportCountryCode)
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isPassportCard = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: PhilippinesPassportModel) -> Void) {
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                
//                // Resetting model if needed
//                resetCheck: if ResetEveryMilliseconds >= 0 {
//                    let currentTimeMs = Date().timeIntervalSince1970 * 1000
//                    guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//                    PreviousResetTime = currentTimeMs
//
//                    Reset()
//                }
//                
//                let lineText = line.text.replacingOccurrences(of: " ", with: "").fixMRZGarbage()
//                
//                if (lineText.count == 44 && Parser.Line1Regex.matches(lineText) && !Parser.Line1Parsed && !Parser.Line2Parsed) {
//                    Parser.ParseLine1(from: lineText)
//                } else if (lineText.count == 44 && Parser.Line2Regex.matches(lineText) && Parser.Line1Parsed && !Parser.Line2Parsed && lineText != Parser.Line1) {
//                    Parser.ParseLine2(from: lineText)
//                    break outer
//                }
//            }
//        }
//    
//        if Parser.Line1Parsed && Parser.Line2Parsed, let model = TD3ModelToPhilippinesPassportModel(Parser.Model) {
//            success(model)
//            Reset()
//        }
//        
//    }
//    
//    mutating func ParsePartialScan(from result: Text, success: @escaping (_ model: PhilippinesPassportModel) -> Void) {
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                
//                // Resetting model if needed
//                resetCheck: if ResetEveryMilliseconds >= 0 {
//                    let currentTimeMs = Date().timeIntervalSince1970 * 1000
//                    guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//                    PreviousResetTime = currentTimeMs
//
//                    Reset()
//                }
//                
//                if !isPassportCard {
//                    let resultText = result.text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    
//                    if resultText.contains("passport") || resultText.contains("pasaporte") {
//                        isPassportCard = true
//                    }
//                }
//                
//                if isPassportCard {
//                    
//                    let lineText = line.text.replacingOccurrences(of: " ", with: "").fixMRZGarbage()
//                    
//                    if (lineText.count == 44 && Parser.Line1Regex.matches(lineText) && !Parser.Line1Parsed && !Parser.Line2Parsed) {
//                        Parser.ParseLine1(from: lineText)
//                    } else if (lineText.count == 44 && Parser.Line2Regex.matches(lineText) && Parser.Line1Parsed && !Parser.Line2Parsed && lineText != Parser.Line1) {
//                        Parser.ParseLine2(from: lineText)
//                        break outer
//                    }
//                    
//                    frames = frames + 1
//                }
//                
//                
//            }
//        }
//    
//        if Parser.Line1Parsed && Parser.Line2Parsed || frames >= maxFrames || getCardTrys >= 6, let model = TD3ModelToPhilippinesPassportModel(Parser.Model) {
//            success(model)
//            Reset()
//        }
//        
//        getCardTrys = getCardTrys + 1
//        
//    }
    
    // MARK: Private Methods
    private func Reset() {
        Parser.Reset()
    }
    
    private func TD3ModelToPhilippinesPassportModel(_ td3Model: TD3Model) -> PhilippinesPassportModel? {
        let model = PhilippinesPassportModel()
        
        model.MRZLine1 = td3Model.MRZLine1
        model.MRZLine2 = td3Model.MRZLine2
        
        model.PassportType = td3Model.DocumentType
        model.IssuingCountryCode = td3Model.IssuingCountryCode
        model.Surname = td3Model.Surname
        model.Names = td3Model.Names
        
        model.PassportNumber = td3Model.DocumentNumber
        model.PassportNumberCheckDigit = td3Model.DocumentNumberCheckDigit
        model.Nationality = td3Model.NationalityCountryCode
        model.DateOfBirth = td3Model.DateOfBirth
        model.DateOfBirthCheckDigit = td3Model.DateOfBirthCheckDigit
        model.Sex = td3Model.Sex
        model.DateOfExpiry = td3Model.DateOfExpiry
        model.DateOfExpiryCheckDigit = td3Model.DateOfExpiryCheckDigit
        model.CompositeCheckDigit = td3Model.CompositeCheckDigit
        
        return model
    }
    
}
