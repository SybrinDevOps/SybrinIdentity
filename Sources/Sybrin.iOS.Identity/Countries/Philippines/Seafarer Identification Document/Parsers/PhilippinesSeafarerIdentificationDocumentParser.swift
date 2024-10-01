//
//  PhilippinesSeafarerIdentificationDocumentParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin.IOS.Common
import MLKitBarcodeScanning
import Foundation
import MLKitVision 
import MLKitFaceDetection 

////import MLKit
struct PhilippinesSeafarerIdentificationDocumentParser {
    
    // MARK: Private Properties
    // Parser
    private let Parser = TraditionalTD1Parser()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isSid = false
    var isSidBack = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesSeafarerIdentificationDocumentModel) -> Void) {
//        let model = PhilippinesSeafarerIdentificationDocumentModel()
//        
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                let lineText = line.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").lowercased()
//                
//                if lineText.count != 13 {
//                    continue inner
//                }
//                
//                let lineTextFixed = lineText.substring(to: 4).replaceCommonCharactersWithLetters() + lineText.substring(from: 4).replaceCommonCharactersWithNumbers()
//                
//                if !lineTextFixed.contains("idno") {
//                    continue inner
//                }
//                
//                model.IdentityNumber = lineTextFixed.substring(from: 4)
//                success(model)
//                break outer
//            }
//        }
//    }
    
//    mutating func ParseBack(from result: Text, success: @escaping (_ model: PhilippinesSeafarerIdentificationDocumentModel) -> Void) {
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
//                let lineText = line.text.replacingOccurrences(of: " ", with: "").fixMRZGarbage(completeLength: 30)
//                
//                if (lineText.count == 30 && Parser.Line1Regex.matches(lineText) && !Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed) {
//                    Parser.ParseLine1(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line2Regex.matches(lineText) && Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1) {
//                    Parser.ParseLine2(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line3Regex.matches(lineText) && Parser.Line1Parsed && Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1 && lineText != Parser.Line2) {
//                    Parser.ParseLine3(from: lineText)
//                    break outer
//                }
//            }
//        }
//    
//        if Parser.Line1Parsed && Parser.Line2Parsed && Parser.Line3Parsed, let model = TD1ModelToPhilippinesSeafarerIdentificationDocumentModel(Parser.Model) {
//            success(model)
//            Reset()
//            
//        }
//        
//    }
//    
//    // MARK:- Partial Scans
//    
//    mutating
//    func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesSeafarerIdentificationDocumentModel) -> Void) {
//        let model = PhilippinesSeafarerIdentificationDocumentModel()
//        
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                let lineText = line.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").lowercased()
//                
//                if !isSid {
//                    if lineText.contains("sid") {
//                        isSid = true
//                    }
//                }
//                
//                if isSid  {
//                    if lineText.count != 13 {
//                        continue inner
//                    }
//                    
//                    let lineTextFixed = lineText.substring(to: 4).replaceCommonCharactersWithLetters() + lineText.substring(from: 4).replaceCommonCharactersWithNumbers()
//                    
//                    if !lineTextFixed.contains("idno") {
//                        continue inner
//                    }
//                    
//                    model.IdentityNumber = lineTextFixed.substring(from: 4)
//                    frames = frames + 1
//                }
//                
//                if frames >= maxFrames || getCardTrys > 6 {
//                    success(model)
//                    ResetFrames()
//                }
//                
//                getCardTrys = getCardTrys + 1
//                break outer
//            }
//        }
//    }
//    
//    mutating func ParseBackPartialScan(from result: Text, success: @escaping (_ model: PhilippinesSeafarerIdentificationDocumentModel) -> Void) {
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
//                let lineText = line.text.replacingOccurrences(of: " ", with: "").fixMRZGarbage(completeLength: 30)
//                
//                if (lineText.count == 30 && Parser.Line1Regex.matches(lineText) && !Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed) {
//                    Parser.ParseLine1(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line2Regex.matches(lineText) && Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1) {
//                    Parser.ParseLine2(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line3Regex.matches(lineText) && Parser.Line1Parsed && Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1 && lineText != Parser.Line2) {
//                    Parser.ParseLine3(from: lineText)
//                    break outer
//                }
//            }
//        }
//    
//        if Parser.Line1Parsed && Parser.Line2Parsed && Parser.Line3Parsed || frames >= maxFrames, let model = TD1ModelToPhilippinesSeafarerIdentificationDocumentModel(Parser.Model) {
//            success(model)
//            Reset()
//            ResetFrames()
//        }
//        
//        frames = frames + 1
//        
//    }
    
    // MARK: Private Methods
    private func Reset() {
        Parser.Reset()
        
    }
    
    private func TD1ModelToPhilippinesSeafarerIdentificationDocumentModel(_ td1Model: TD1Model) -> PhilippinesSeafarerIdentificationDocumentModel? {
        let model = PhilippinesSeafarerIdentificationDocumentModel()
        
        model.MRZLine1 = td1Model.MRZLine1
        model.MRZLine2 = td1Model.MRZLine2
        model.MRZLine3 = td1Model.MRZLine3
        
        model.DocumentType = td1Model.DocumentType
        model.IssuingCountryCode = td1Model.IssuingCountryCode
        model.IdentityNumber = td1Model.DocumentNumber
        model.IdentityNumberCheckDigit = td1Model.DocumentNumberCheckDigit
        model.OptionalData1 = td1Model.OptionalData1
        
        model.DateOfBirth = td1Model.DateOfBirth
        model.DateOfBirthCheckDigit = td1Model.DateOfBirthCheckDigit
        model.Sex = td1Model.Sex
        model.DateOfExpiry = td1Model.DateOfExpiry
        model.DateOfExpiryCheckDigit = td1Model.DateOfExpiryCheckDigit
        model.Nationality = td1Model.NationalityCountryCode
        model.OptionalData2 = td1Model.OptionalData2
        model.CompositeCheckDigit = td1Model.CompositeCheckDigit
        
        model.Surname = td1Model.Surname
        model.Names = td1Model.Names
        
        return model
    }
    
    private mutating func ResetFrames(){
        frames = 0
        getCardTrys = 0
    }
    
}
