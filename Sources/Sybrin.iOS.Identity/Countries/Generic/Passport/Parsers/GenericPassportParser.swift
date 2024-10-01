//
//  GenericPassportParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/08/17.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
////import MLKit
import Foundation

struct GenericPassportParser {
    
    // MARK: Private Properties
    // Parser
    private let Parser = TraditionalTD3Parser(issuingCountryCode:nil)
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: GenericPassportModel) -> Void) {
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
//        if Parser.Line1Parsed && Parser.Line2Parsed, let model = TD3ModelToGenericPassportModel(Parser.Model) {
//            success(model)
//            Reset()
//        }
//        
//    }
//    
    // MARK: Private Methods
    private func Reset() {
        Parser.Reset()
    }
    
    private func TD3ModelToGenericPassportModel(_ td3Model: TD3Model) -> GenericPassportModel? {
        let model = GenericPassportModel()
        
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
        model.OptionalData = td3Model.OptionalData
        model.OptionalDataCheckDigit = td3Model.OptionalDataCheckDigit
        model.CompositeCheckDigit = td3Model.CompositeCheckDigit
        
        return model
    }
    
}
