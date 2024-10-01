//
//  PhilippinesQCIdentificationCardParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Matthew Dickson on 2022/11/08.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//

////import MLKit
import Sybrin_iOS_Common //import Sybrin.IOS.Common
import MLKitBarcodeScanning
import Foundation
import MLKitVision 
import MLKitFaceDetection 

struct PhilippinesQCIdentificationCardParser {
    
    // MARK: Private Properties
    private var FullNameParsed = false
    private var SexParsed = false
    private var DateOfBirthParsed = false
    private var CivilStatusParsed = false
    private var BloodTypeParsed = false
    private var DateIssuedParsed = false
    private var ValidUntilParsed = false
    private var DisabilityTypeParsed = false
    private var CitizenTypeParsed = false
    private var AddressParsed = false
    private var QCReferenceNumberParsed = false
    private var Model = PhilippinesQCIdentificationCardModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 30
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesQCIdentificationCardModel) -> Void) {
//        
//        // Resetting model if needed
//        resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//
//            Reset()
//        }
//        
//        let sybrinItemGroup = MLKitHelper.BlocksToSybrinItemGroup(result.blocks)
//        
//        // Finding Names
//        if !FullNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return ((itemText.contains("last") || itemText.contains("first")))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                FullNameParsed = true
//                Model.FullName = String(lineBelowText)
//                break search
//            }
//        }
//        
//        
//        // Finding Blood type
//        if !BloodTypeParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return ((itemText.contains("blood") || itemText.contains("type")))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 3 else { continue search }
//                
//                
//                BloodTypeParsed = true
//                Model.BloodType = String(lineBelowText)
//                break search
//            }
//        }
//        
//        
//        // Finding citizen type
//        if !CitizenTypeParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return ((itemText.contains("cardholder") || itemText.contains("signature")))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                CitizenTypeParsed = true
//                Model.CitizenType = String(lineBelowText)
//                break search
//            }
//        }
//        
//        
//        // Finding civil status
//        if !CivilStatusParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return ((itemText.contains("civil") || itemText.contains("status")))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                CivilStatusParsed = true
//                Model.CivilStatus = String(lineBelowText)
//                break search
//            }
//        }
//        
//        
//        // Finding address
//        if !AddressParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.count >= 20)
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                
//                let potentialAddress = potentialMatch.Text
//                
//                if(Model.FullName != potentialAddress){
//                    AddressParsed = true
//                    Model.Address = String(potentialAddress)
//                }
//                break search
//            }
//        }
//        
//        
//        // Finding Sex
//        if !SexParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("sex"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Center) else { continue search }
//                
//                switch elementBelow.Text.replaceCommonCharactersWithLetters().lowercased() {
//                    case "m":
//                        SexParsed = true
//                        Model.Sex = .Male
//                        break search
//                    case "f":
//                        SexParsed = true
//                        Model.Sex = .Female
//                        break search
//                    default: continue search
//                }
//            }
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("birth"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                guard elementBelowText.count == 8 else { continue search }
//
//                guard let dateOfBirth = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                
//                guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                DateOfBirthParsed = true
//                Model.DateOfBirth = dateOfBirth
//                break search
//            }
//        }
//        
//
//        
//        
//        // Finding Date issued
//        if !DateIssuedParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("issue"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                guard elementBelowText.count == 8 else { continue search }
//
//                guard let dateIssued = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//
//                DateIssuedParsed = true
//                Model.DateIssued = dateIssued
//                break search
//            }
//        }
//        
//        
//        // Finding Expiration Date
//        if !ValidUntilParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("valid"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                guard elementBelowText.count == 8 else { continue search }
//
//                guard let validUntil = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//
//                ValidUntilParsed = true
//                Model.ValidUntil = validUntil
//                break search
//            }
//        }
//        
//        
//        // Finding QC Reference number
//        if !QCReferenceNumberParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.count >= 14)
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                
//                let referenceNumber = potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//                QCReferenceNumberParsed = true
//                Model.QCReferenceNumber = referenceNumber
//                break search
//            }
//        }
//        
//        
//        if SybrinIdentityConfiguration.EnablePartialScanning{
//            frames += 1
//        }
//
//        if AreRequiredFrontTextFieldsParsed() || maxFrames < frames{
//            success(Model)
//            Reset()
//        }
//        
//    }
    
    
    mutating func ParseBackBarcode(from result: Barcode, success: @escaping (_ model: PhilippinesQCIdentificationCardModel) -> Void) {
        if let barcodeResult = result.displayValue {
            let model = ParseBarcode(barcodeResult)!
            success(model)
        }
    }
    
    
    // MARK: Private Methods
    private func ParseBarcode(_ barcodeResult: String) -> PhilippinesQCIdentificationCardModel? {
        let model = PhilippinesQCIdentificationCardModel()
        let barcodeResultArray = barcodeResult.components(separatedBy: "|")
        model.BarcodeData = barcodeResultArray[0]
        
        return model
    }
    

    
    mutating private func Reset() {
        
        FullNameParsed = false
        SexParsed = false
        DateOfBirthParsed = false
        CivilStatusParsed = false
        BloodTypeParsed = false
        DateIssuedParsed = false
        ValidUntilParsed = false
        DisabilityTypeParsed = false
        CitizenTypeParsed = false
        AddressParsed = false
        QCReferenceNumberParsed = false
        Model = PhilippinesQCIdentificationCardModel()
        
    }
    
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return FullNameParsed && SexParsed && DateOfBirthParsed && CivilStatusParsed && BloodTypeParsed && DateIssuedParsed && ValidUntilParsed && DisabilityTypeParsed && CitizenTypeParsed && AddressParsed && QCReferenceNumberParsed
    }
    
    
}
