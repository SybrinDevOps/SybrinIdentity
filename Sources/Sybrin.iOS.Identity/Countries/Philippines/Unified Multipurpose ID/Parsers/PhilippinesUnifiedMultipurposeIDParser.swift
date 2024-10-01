//
//  PhilippinesUnifiedMultipurposeIDParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin.IOS.Common
import MLKitBarcodeScanning
import Foundation
import MLKitVision 
import MLKitFaceDetection 

struct PhilippinesUnifiedMultipurposeIDParser {
    
    // MARK: Private Properties
    private var CommonReferenceNumberParsed = false
    private var SurnameParsed = false
    private var GivenNameParsed = false
    private var MiddleNameParsed = false
    private var SexParsed = false
    private var DateOfBirthParsed = false
    private var AddressParsed = false
    private var Model = PhilippinesUnifiedMultipurposeIDModel()
    
    
    private var isUMID_Card = false
    private var getCardTrys = 0
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesUnifiedMultipurposeIDModel) -> Void) {
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
//        // Finding Common Reference Number
//        if !CommonReferenceNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
//                return (itemText.contains("crn") && itemText.count == 15)
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let potentialCRN = String(potentialMatch.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithNumbers().suffix(15))
//                
//                let potentialCRNWithoutDashes = potentialCRN.replacingOccurrences(of: "-", with: "")
//                
//                guard RegexConstants.Philippines_CommonReferenceNumber.matches(potentialCRNWithoutDashes) else {
//                    continue search }
//                
//                CommonReferenceNumberParsed = true
//                Model.CommonReferenceNumber = potentialCRN
//                break search
//            }
//        }
//        
//        // Finding Surname
//        if !SurnameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("surname"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var potentialSurname = ""
//                
//                guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                
//                let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                
//                if restOfLine.count > 0 {
//                    potentialSurname = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialSurname = lineBelowText
//                } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialSurname = lineRightText
//                } else {
//                    continue search
//                }
//                
//                guard potentialSurname.count >= 2 && potentialSurname.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialSurname) else { continue search }
//                
//                SurnameParsed = true
//                Model.Surname = potentialSurname
//                break search
//            }
//        }
//        
//        // Finding Given Name
//        if !GivenNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("given"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var potentialGivenName = ""
//                
//                guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                
//                let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                
//                if restOfLine.count > 0 {
//                    potentialGivenName = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialGivenName = lineBelowText
//                } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialGivenName = lineRightText
//                } else {
//                    continue search
//                }
//                
//                guard potentialGivenName.count >= 2 && potentialGivenName.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialGivenName) else { continue search }
//                
//                GivenNameParsed = true
//                Model.GivenName = potentialGivenName
//                break search
//            }
//        }
//        
//        // Finding Middle Name
//        if !MiddleNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("middle"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var potentialMiddleName = ""
//                
//                guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                
//                let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                
//                if restOfLine.count > 0 {
//                    potentialMiddleName = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialMiddleName = lineBelowText
//                } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialMiddleName = lineRightText
//                } else {
//                    continue search
//                }
//                
//                guard potentialMiddleName.count >= 2 && potentialMiddleName.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialMiddleName) else { continue search }
//                
//                MiddleNameParsed = true
//                Model.MiddleName = potentialMiddleName
//                break search
//            }
//        }
//        
//        // Finding Sex
//        if !SexParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("sex"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if lineText.count < 4 {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 4) else { continue search }
//                    
//                    let lineRightText = lineRight.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithLetters().lowercased()
//                    
//                    if lineRightText == "male" || lineRightText == "female" {
//                        SexParsed = true
//                        Model.Sex = (lineRightText == "male") ? .Male : .Female
//                        break search
//                    }
//                }
//                
//                guard let range = lineText.range(of: "sex"), lineText.distance(from: lineText.startIndex, to: range.upperBound) + 1 <= lineText.count else { continue search }
//                
//                let potentialSexChar = String(lineText[range.upperBound..<lineText.index(range.upperBound, offsetBy: 1)])
//                
//                if potentialSexChar.lowercased() == "m" {
//                    SexParsed = true
//                    Model.Sex = .Male
//                    break search
//                } else if potentialSexChar.lowercased() == "f" {
//                    SexParsed = true
//                    Model.Sex = .Female
//                    break search
//                } else {
//                    continue search
//                }
//            }
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("date") && itemText.contains("birth"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let potentialDateOfBirth = String(potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "").suffix(8))
//                
//                guard let dateOfBirth = potentialDateOfBirth.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                
//                guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                DateOfBirthParsed = true
//                Model.DateOfBirth = dateOfBirth
//                break search
//            }
//        }
//        
//        // Finding Address
//        if !AddressParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("addres"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var address = ""
//                var comparingLine: ProtocolSybrinItem = potentialMatch
//                potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    
//                    let lineBelowText = lineBelow.Text
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { break potentialLine }
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
//        if !CommonReferenceNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
//                return (itemText.contains("crn") && itemText.count == 15)
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let potentialCRN = String(potentialMatch.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithNumbers().suffix(15))
//                
//                let potentialCRNWithoutDashes = potentialCRN.replacingOccurrences(of: "-", with: "")
//                
//                guard RegexConstants.Philippines_CommonReferenceNumber.matches(potentialCRNWithoutDashes) else {
//                    continue search }
//                
//                CommonReferenceNumberParsed = true
//                Model.CommonReferenceNumber = potentialCRN
//                break search
//            }
//        }
//        
//        // Finding Surname
//        if !SurnameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("surname"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var potentialSurname = ""
//                
//                guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                
//                let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                
//                if restOfLine.count > 0 {
//                    potentialSurname = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialSurname = lineBelowText
//                } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialSurname = lineRightText
//                } else {
//                    continue search
//                }
//                
//                guard potentialSurname.count >= 2 && potentialSurname.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialSurname) else { continue search }
//                
//                SurnameParsed = true
//                Model.Surname = potentialSurname
//                break search
//            }
//        }
//        
//        // Finding Given Name
//        if !GivenNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("given"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var potentialGivenName = ""
//                
//                guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                
//                let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                
//                if restOfLine.count > 0 {
//                    potentialGivenName = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialGivenName = lineBelowText
//                } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialGivenName = lineRightText
//                } else {
//                    continue search
//                }
//                
//                guard potentialGivenName.count >= 2 && potentialGivenName.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialGivenName) else { continue search }
//                
//                GivenNameParsed = true
//                Model.GivenName = potentialGivenName
//                break search
//            }
//        }
//        
//        // Finding Middle Name
//        if !MiddleNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("middle"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var potentialMiddleName = ""
//                
//                guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                
//                let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                
//                if restOfLine.count > 0 {
//                    potentialMiddleName = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialMiddleName = lineBelowText
//                } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                    
//                    potentialMiddleName = lineRightText
//                } else {
//                    continue search
//                }
//                
//                guard potentialMiddleName.count >= 2 && potentialMiddleName.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialMiddleName) else { continue search }
//                
//                MiddleNameParsed = true
//                Model.MiddleName = potentialMiddleName
//                break search
//            }
//        }
//        
//        // Finding Sex
//        if !SexParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("sex"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if lineText.count < 4 {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 4) else { continue search }
//                    
//                    let lineRightText = lineRight.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithLetters().lowercased()
//                    
//                    if lineRightText == "male" || lineRightText == "female" {
//                        SexParsed = true
//                        Model.Sex = (lineRightText == "male") ? .Male : .Female
//                        break search
//                    }
//                }
//                
//                guard let range = lineText.range(of: "sex"), lineText.distance(from: lineText.startIndex, to: range.upperBound) + 1 <= lineText.count else { continue search }
//                
//                let potentialSexChar = String(lineText[range.upperBound..<lineText.index(range.upperBound, offsetBy: 1)])
//                
//                if potentialSexChar.lowercased() == "m" {
//                    SexParsed = true
//                    Model.Sex = .Male
//                    break search
//                } else if potentialSexChar.lowercased() == "f" {
//                    SexParsed = true
//                    Model.Sex = .Female
//                    break search
//                } else {
//                    continue search
//                }
//            }
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("date") && itemText.contains("birth"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let potentialDateOfBirth = String(potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "").suffix(8))
//                
//                guard let dateOfBirth = potentialDateOfBirth.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                
//                guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                DateOfBirthParsed = true
//                Model.DateOfBirth = dateOfBirth
//                break search
//            }
//        }
//        
//        // Finding Address
//        if !AddressParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("addres"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var address = ""
//                var comparingLine: ProtocolSybrinItem = potentialMatch
//                potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                    
//                    let lineBelowText = lineBelow.Text
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { break potentialLine }
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
//        
//        if AreRequiredFrontTextFieldsParsed() {
//            success(Model)
//            Reset()
//        }
//        
//    }
    
    // MARK: -
    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesUnifiedMultipurposeIDModel) -> Void) {
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
//        // Finding Common Reference Number
//        
//        if !isUMID_Card {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if (itemText.contains("unified")) {
//                    isUMID_Card = true
//                }
//                return (itemText.contains("unified"))
//            }
//        }
//        
//        if isUMID_Card {
//        
//            if !CommonReferenceNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
//                    return (itemText.contains("crn") && itemText.count == 15)
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let potentialCRN = String(potentialMatch.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithNumbers().suffix(15))
//                    
//                    let potentialCRNWithoutDashes = potentialCRN.replacingOccurrences(of: "-", with: "")
//                    
//                    guard RegexConstants.Philippines_CommonReferenceNumber.matches(potentialCRNWithoutDashes) else {
//                        continue search }
//                    
//                    CommonReferenceNumberParsed = true
//                    Model.CommonReferenceNumber = potentialCRN
//                    break search
//                }
//            }
//            
//            // Finding Surname
//            if !SurnameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("surname"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var potentialSurname = ""
//                    
//                    guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                    
//                    let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                    
//                    if restOfLine.count > 0 {
//                        potentialSurname = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                    } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                        let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                        
//                        potentialSurname = lineBelowText
//                    } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                        let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                        
//                        potentialSurname = lineRightText
//                    } else {
//                        continue search
//                    }
//                    
//                    guard potentialSurname.count >= 2 && potentialSurname.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(potentialSurname) else { continue search }
//                    
//                    SurnameParsed = true
//                    Model.Surname = potentialSurname
//                    break search
//                }
//            }
//            
//            // Finding Given Name
//            if !GivenNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("given"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var potentialGivenName = ""
//                    
//                    guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                    
//                    let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                    
//                    if restOfLine.count > 0 {
//                        potentialGivenName = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                    } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                        let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                        
//                        potentialGivenName = lineBelowText
//                    } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                        let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                        
//                        potentialGivenName = lineRightText
//                    } else {
//                        continue search
//                    }
//                    
//                    guard potentialGivenName.count >= 2 && potentialGivenName.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(potentialGivenName) else { continue search }
//                    
//                    GivenNameParsed = true
//                    Model.GivenName = potentialGivenName
//                    break search
//                }
//            }
//            
//            // Finding Middle Name
//            if !MiddleNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("middle"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var potentialMiddleName = ""
//                    
//                    guard let indexOfName = potentialMatch.Text.lowercased().indexOf(str: "name") else { continue search }
//                    
//                    let restOfLine = potentialMatch.Text.substring(from: indexOfName + 4)
//                    
//                    if restOfLine.count > 0 {
//                        potentialMiddleName = potentialMatch.Text.substring(from: indexOfName + 4).replaceCommonCharactersWithLetters()
//                    } else if let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) {
//                        let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                        
//                        potentialMiddleName = lineBelowText
//                    } else if let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                        let lineRightText = lineRight.Text.replaceCommonCharactersWithLetters()
//                        
//                        potentialMiddleName = lineRightText
//                    } else {
//                        continue search
//                    }
//                    
//                    guard potentialMiddleName.count >= 2 && potentialMiddleName.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(potentialMiddleName) else { continue search }
//                    
//                    MiddleNameParsed = true
//                    Model.MiddleName = potentialMiddleName
//                    break search
//                }
//            }
//            
//            // Finding Sex
//            if !SexParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("sex"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    
//                    if lineText.count < 4 {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 4) else { continue search }
//                        
//                        let lineRightText = lineRight.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithLetters().lowercased()
//                        
//                        if lineRightText == "male" || lineRightText == "female" {
//                            SexParsed = true
//                            Model.Sex = (lineRightText == "male") ? .Male : .Female
//                            break search
//                        }
//                    }
//                    
//                    guard let range = lineText.range(of: "sex"), lineText.distance(from: lineText.startIndex, to: range.upperBound) + 1 <= lineText.count else { continue search }
//                    
//                    let potentialSexChar = String(lineText[range.upperBound..<lineText.index(range.upperBound, offsetBy: 1)])
//                    
//                    if potentialSexChar.lowercased() == "m" {
//                        SexParsed = true
//                        Model.Sex = .Male
//                        break search
//                    } else if potentialSexChar.lowercased() == "f" {
//                        SexParsed = true
//                        Model.Sex = .Female
//                        break search
//                    } else {
//                        continue search
//                    }
//                }
//            }
//            
//            // Finding Date Of Birth
//            if !DateOfBirthParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("date") && itemText.contains("birth"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let potentialDateOfBirth = String(potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "").suffix(8))
//                    
//                    guard let dateOfBirth = potentialDateOfBirth.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                    
//                    guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                    DateOfBirthParsed = true
//                    Model.DateOfBirth = dateOfBirth
//                    break search
//                }
//            }
//            
//            // Finding Address
//            if !AddressParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("addres"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var address = ""
//                    var comparingLine: ProtocolSybrinItem = potentialMatch
//                    potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Inline) {
//                        
//                        let lineBelowText = lineBelow.Text
//                        
//                        guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { break potentialLine }
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
//            frames = frames + 1
//        }
//        
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
        CommonReferenceNumberParsed = false
        SurnameParsed = false
        GivenNameParsed = false
        MiddleNameParsed = false
        SexParsed = false
        DateOfBirthParsed = false
        AddressParsed = false
        Model = PhilippinesUnifiedMultipurposeIDModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return CommonReferenceNumberParsed && SurnameParsed && GivenNameParsed && SexParsed && DateOfBirthParsed  && AddressParsed
    }

}
