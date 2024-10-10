//
//  PhilippinesPostalIDParser.swift
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

struct PhilippinesPostalIDParser {
    
    // MARK: Private Properties
    private var FullNameParsed = false
    private var PostalReferenceNumberParsed = false
    private var AddressParsed = false
    private var DateOfBirthParsed = false
    private var ValidUntilParsed = false
    private var NationalityParsed = false
    private var IssuingPostOfficeParsed = false
    private var Model = PhilippinesPostalIDModel()
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isPIDCard = false
    var getCardTrys = 0
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesPostalIDModel) -> Void) {
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
//        // Finding Card Type
//        if Model.CardType == "Unspecified" {
//            let resultText = result.text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//            if resultText.contains("basic") {
//                Model.CardType = "Basic"
//            } else if resultText.contains("premium") {
//                Model.CardType = "Premium"
//            }
//        }
//        
//        // Finding Full Name
//        if !FullNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("surname") || itemText.contains("first") || itemText.contains("middle") || itemText.contains("name") || itemText.contains("initial") || itemText.contains("suffix"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                FullNameParsed = true
//                Model.FullName = lineBelowText
//                break search
//            }
//        }
//        
//        // Finding Postal Reference Number
//        if !PostalReferenceNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("prn"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "")
//                
//                guard let prnIndex = lineText.lowercased().indexOf(str: "prn"), prnIndex != -1 && lineText.count >= 15 else { continue search }
//                
//                lineText = lineText.substring(from: prnIndex + 3, length: 12)
//                
//                PostalReferenceNumberParsed = true
//                Model.PostalReferenceNumber = lineText
//                break search
//            }
//        }
//        
//        // Finding Address
//        if !AddressParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("address"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var address = ""
//                var comparingLine: ProtocolSybrinItem = potentialMatch
//                potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    
//                    let lineBelowText = lineBelow.Text
//                    
//                    guard !lineBelowText.replaceCommonCharactersWithLetters().lowercased().contains("birth") && !lineBelowText.replaceCommonCharactersWithLetters().lowercased().contains("nationality") else { break potentialLine }
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 45 else { break potentialLine }
//                    
//                    address += "\((address.count > 0) ? "\n" : "")\(lineBelowText)"
//
//                    comparingLine = lineBelow
//                }
//                
//                if address.count > 0 {
//                    AddressParsed = true
//                    Model.Address = address
//                    break search
//                }
//            }
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("birth"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                
//                guard lineBelow.Text.replacingOccurrences(of: " ", with: "").count >= 7 else { continue search }
//                
//                var lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "").substring(to: 7)
//                
//                lineBelowText = lineBelowText.substring(to: 2).replaceCommonCharactersWithNumbers() + lineBelowText.substring(from: 2, length: 3).replaceCommonCharactersWithLetters() + lineBelowText.substring(from: 5).replaceCommonCharactersWithNumbers()
//                
//                guard let date = lineBelowText.stringToDate(withFormat: "ddMMMyy") else { continue search }
//                
//                guard date.isRealisticBirthDate else { continue search }
//                
//                DateOfBirthParsed = true
//                Model.DateOfBirth = date
//                break search
//            }
//        }
//        
//        // Finding Valid Until
//        if !ValidUntilParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("valid") && itemText.contains("until"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                
//                var lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "")
//                
//                if Model.CardType == "Basic" && lineBelowText.count > 7 {
//                    lineBelowText = lineBelowText.substring(to: 7)
//                } else if Model.CardType == "Premium" && lineBelowText.count > 7 {
//                    lineBelowText = String(lineBelowText.suffix(7))
//                }
//                
//                lineBelowText = lineBelowText.substring(to: 2).replaceCommonCharactersWithNumbers() + lineBelowText.substring(from: 2, length: 3).replaceCommonCharactersWithLetters() + lineBelowText.substring(from: 5).replaceCommonCharactersWithNumbers()
//                
//                guard lineBelowText.count == 7 else { continue search }
//                
//                guard let date = lineBelowText.stringToDate(withFormat: "ddMMMyy") else { continue search }
//                
//                ValidUntilParsed = true
//                Model.ValidUntil = date
//                break search
//            }
//        }
//        
//        // Finding Nationality
//        if !NationalityParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("nationality"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard elementBelowText.count >= 2 && elementBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(elementBelowText) else { continue search }
//                
//                NationalityParsed = true
//                Model.Nationality = elementBelowText
//                break search
//            }
//        }
//        
//        // Finding Issuing Post Office
//        if !IssuingPostOfficeParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("issuing") || itemText.contains("office"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                
//                var lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                if Model.CardType == "Basic" && lineBelowText.count > 10 {
//                    lineBelowText = lineBelowText.substring(from: 10)
//                } else if Model.CardType == "Premium" && lineBelowText.count > 10 {
//                    lineBelowText = lineBelowText.substring(from: 0, to: lineBelowText.count - 10)
//                }
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                IssuingPostOfficeParsed = true
//                Model.IssuingPostOffice = lineBelowText
//                break search
//            }
//        }
//        
//        if AreRequiredFrontTextFieldsParsed() {
//            success(Model)
//            Reset()
//        }
//        
//    }
    
    // MARK: - Partial Scans
    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesPostalIDModel) -> Void) {
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
//        if !isPIDCard {
//            let resultText = result.text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//            
//            if resultText.contains("postal") || resultText.contains("phlpost") {
//                isPIDCard = true
//            }
//        }
//        
//        if isPIDCard {
//            // Finding Card Type
//            if Model.CardType == "Unspecified" {
//                let resultText = result.text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                if resultText.contains("basic") {
//                    Model.CardType = "Basic"
//                } else if resultText.contains("premium") {
//                    Model.CardType = "Premium"
//                }
//            }
//            
//            // Finding Full Name
//            if !FullNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("surname") || itemText.contains("first") || itemText.contains("middle") || itemText.contains("name") || itemText.contains("initial") || itemText.contains("suffix"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                    
//                    FullNameParsed = true
//                    Model.FullName = lineBelowText
//                    break search
//                }
//            }
//            
//            // Finding Postal Reference Number
//            if !PostalReferenceNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("prn"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "")
//                    
//                    guard let prnIndex = lineText.lowercased().indexOf(str: "prn"), prnIndex != -1 && lineText.count >= 15 else { continue search }
//                    
//                    lineText = lineText.substring(from: prnIndex + 3, length: 12)
//                    
//                    PostalReferenceNumberParsed = true
//                    Model.PostalReferenceNumber = lineText
//                    break search
//                }
//            }
//            
//            // Finding Address
//            if !AddressParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("address"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var address = ""
//                    var comparingLine: ProtocolSybrinItem = potentialMatch
//                    potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                        
//                        let lineBelowText = lineBelow.Text
//                        
//                        guard !lineBelowText.replaceCommonCharactersWithLetters().lowercased().contains("birth") && !lineBelowText.replaceCommonCharactersWithLetters().lowercased().contains("nationality") else { break potentialLine }
//                        
//                        guard lineBelowText.count >= 2 && lineBelowText.count <= 45 else { break potentialLine }
//                        
//                        address += "\((address.count > 0) ? "\n" : "")\(lineBelowText)"
//
//                        comparingLine = lineBelow
//                    }
//                    
//                    if address.count > 0 {
//                        AddressParsed = true
//                        Model.Address = address
//                        break search
//                    }
//                }
//            }
//            
//            // Finding Date Of Birth
//            if !DateOfBirthParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("birth"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    guard lineBelow.Text.replacingOccurrences(of: " ", with: "").count >= 7 else { continue search }
//                    
//                    var lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "").substring(to: 7)
//                    
//                    lineBelowText = lineBelowText.substring(to: 2).replaceCommonCharactersWithNumbers() + lineBelowText.substring(from: 2, length: 3).replaceCommonCharactersWithLetters() + lineBelowText.substring(from: 5).replaceCommonCharactersWithNumbers()
//                    
//                    guard let date = lineBelowText.stringToDate(withFormat: "ddMMMyy") else { continue search }
//                    
//                    guard date.isRealisticBirthDate else { continue search }
//                    
//                    DateOfBirthParsed = true
//                    Model.DateOfBirth = date
//                    break search
//                }
//            }
//            
//            // Finding Valid Until
//            if !ValidUntilParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("valid") && itemText.contains("until"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    var lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "")
//                    
//                    if Model.CardType == "Basic" && lineBelowText.count > 7 {
//                        lineBelowText = lineBelowText.substring(to: 7)
//                    } else if Model.CardType == "Premium" && lineBelowText.count > 7 {
//                        lineBelowText = String(lineBelowText.suffix(7))
//                    }
//                    
//                    lineBelowText = lineBelowText.substring(to: 2).replaceCommonCharactersWithNumbers() + lineBelowText.substring(from: 2, length: 3).replaceCommonCharactersWithLetters() + lineBelowText.substring(from: 5).replaceCommonCharactersWithNumbers()
//                    
//                    guard lineBelowText.count == 7 else { continue search }
//                    
//                    guard let date = lineBelowText.stringToDate(withFormat: "ddMMMyy") else { continue search }
//                    
//                    ValidUntilParsed = true
//                    Model.ValidUntil = date
//                    break search
//                }
//            }
//            
//            // Finding Nationality
//            if !NationalityParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("nationality"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard elementBelowText.count >= 2 && elementBelowText.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(elementBelowText) else { continue search }
//                    
//                    NationalityParsed = true
//                    Model.Nationality = elementBelowText
//                    break search
//                }
//            }
//            
//            // Finding Issuing Post Office
//            if !IssuingPostOfficeParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("issuing") || itemText.contains("office"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    var lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    if Model.CardType == "Basic" && lineBelowText.count > 10 {
//                        lineBelowText = lineBelowText.substring(from: 10)
//                    } else if Model.CardType == "Premium" && lineBelowText.count > 10 {
//                        lineBelowText = lineBelowText.substring(from: 0, to: lineBelowText.count - 10)
//                    }
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                    
//                    IssuingPostOfficeParsed = true
//                    Model.IssuingPostOffice = lineBelowText
//                    break search
//                }
//            }
//            
//            frames = frames + 1
//        }
//        
//        if AreRequiredFrontTextFieldsParsed() || frames >= maxFrames || getCardTrys >= 6 {
//            success(Model)
//            Reset()
//        }
//        
//        getCardTrys = getCardTrys + 1
//        
//    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        FullNameParsed = false
        PostalReferenceNumberParsed = false
        AddressParsed = false
        DateOfBirthParsed = false
        ValidUntilParsed = false
        NationalityParsed = false
        IssuingPostOfficeParsed = false
        Model = PhilippinesPostalIDModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return FullNameParsed && PostalReferenceNumberParsed && AddressParsed && DateOfBirthParsed && ValidUntilParsed && NationalityParsed && IssuingPostOfficeParsed
    }

}
