//
//  PhilippinesFirearmsLicenseParser.swift
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

struct PhilippinesFirearmsLicenseParser {
    
    // MARK: Private Properties
    private var FullNameParsed = false
    private var LicenseToOwnAndPossessFirearmNumberParsed = false
    private var QualificationParsed = false
    private var DateApprovedParsed = false
    private var DateExpiryParsed = false
    private var OtherLicensesParsed = false
    private var AddressParsed = false
    private var Model = PhilippinesFirearmsLicenseModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isFAlCard = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesFirearmsLicenseModel) -> Void) {
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
//        // Finding Full Name
//        if !FullNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return ((itemText.contains("last") || itemText.contains("first") || itemText.contains("middle")) && itemText.contains("name"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
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
//        // Finding License To Own And Possess Firearm Number
//        if !LicenseToOwnAndPossessFirearmNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("ltopf") || itemText.contains("ltope"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "")
//                
//                let lineTextSplit = lineText.split(separator: ":")
//                
//                var potentialLicenseToOwnAndPossessFirearmNumber = ""
//                
//                if lineTextSplit.count >= 2 {
//                    potentialLicenseToOwnAndPossessFirearmNumber = String(lineTextSplit[1]).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    let lineRightText = lineRight.Text.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")
//                    
//                    potentialLicenseToOwnAndPossessFirearmNumber = lineRightText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                }
//                
//                LicenseToOwnAndPossessFirearmNumberParsed = true
//                Model.LicenseToOwnAndPossessFirearmNumber = potentialLicenseToOwnAndPossessFirearmNumber
//                break search
//            }
//        }
//        
//        // Finding Qualification
//        if !QualificationParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("qualification"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replaceCommonCharactersWithLetters()
//                
//                let lineTextSplit = lineText.split(separator: ":")
//                
//                var potentialQualification = ""
//                
//                if lineTextSplit.count >= 2 {
//                    potentialQualification = String(lineTextSplit[1]).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    let lineRightText = lineRight.Text.replacingOccurrences(of: ":", with: "")
//                    
//                    potentialQualification = lineRightText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                }
//                
//                QualificationParsed = true
//                Model.Qualification = potentialQualification
//                break search
//            }
//        }
//        
//        // Finding Date Approved
//        if !DateApprovedParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("approved"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                
//                let lineTextSplit = lineText.split(separator: ":")
//                
//                var potentialDateApproved = ""
//                
//                if lineTextSplit.count >= 2 {
//                    potentialDateApproved = String(lineTextSplit[1])
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    potentialDateApproved = lineRight.Text.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                }
//                
//                guard let date = potentialDateApproved.stringToDate(withFormat: "MMMMddyyyy") else { continue search }
//                
//                DateApprovedParsed = true
//                Model.DateApproved = date
//                break search
//            }
//        }
//        
//        // Finding Date Expiry
//        if !DateExpiryParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("expiry"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                
//                let lineTextSplit = lineText.split(separator: ":")
//                
//                var potentialDateExpiry = ""
//                
//                if lineTextSplit.count >= 2 {
//                    potentialDateExpiry = String(lineTextSplit[1])
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    potentialDateExpiry = lineRight.Text.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                }
//                
//                guard let date = potentialDateExpiry.stringToDate(withFormat: "MMMMddyyyy") else { continue search }
//                
//                DateExpiryParsed = true
//                Model.DateExpiry = date
//                break search
//            }
//        }
//        
//        // Finding Other Licenses
//        if !OtherLicensesParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("otherlicenses"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replaceCommonCharactersWithLetters()
//                
//                let lineTextSplit = lineText.split(separator: ":")
//                
//                var potentialOtherLicenses = ""
//                
//                if lineTextSplit.count >= 2 {
//                    potentialOtherLicenses = String(lineTextSplit[1]).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    let lineRightText = lineRight.Text.replacingOccurrences(of: ":", with: "")
//                    
//                    potentialOtherLicenses = lineRightText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                }
//                
//                OtherLicensesParsed = true
//                Model.OtherLicenses = potentialOtherLicenses
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
//                potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Left) {
//                    
//                    let lineBelowText = lineBelow.Text
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
//        if AreRequiredFrontTextFieldsParsed() {
//            success(Model)
//            Reset()
//        }
//        
//    }
//    
//    // MARK: - Partial Scans
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesFirearmsLicenseModel) -> Void) {
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
//        if !isFAlCard {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if itemText.contains("firearms") || itemText.contains("ltopf") {
//                    isFAlCard = true
//                }
//                
//                return itemText.contains("firearms") || itemText.contains("ltopf")
//            }
//        }
//        
//        if isFAlCard {
//            // Finding Full Name
//            if !FullNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return ((itemText.contains("last") || itemText.contains("first") || itemText.contains("middle")) && itemText.contains("name"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
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
//            // Finding License To Own And Possess Firearm Number
//            if !LicenseToOwnAndPossessFirearmNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("ltopf") || itemText.contains("ltope"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "")
//                    
//                    let lineTextSplit = lineText.split(separator: ":")
//                    
//                    var potentialLicenseToOwnAndPossessFirearmNumber = ""
//                    
//                    if lineTextSplit.count >= 2 {
//                        potentialLicenseToOwnAndPossessFirearmNumber = String(lineTextSplit[1]).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                        
//                        let lineRightText = lineRight.Text.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")
//                        
//                        potentialLicenseToOwnAndPossessFirearmNumber = lineRightText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    }
//                    
//                    LicenseToOwnAndPossessFirearmNumberParsed = true
//                    Model.LicenseToOwnAndPossessFirearmNumber = potentialLicenseToOwnAndPossessFirearmNumber
//                    break search
//                }
//            }
//            
//            // Finding Qualification
//            if !QualificationParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("qualification"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replaceCommonCharactersWithLetters()
//                    
//                    let lineTextSplit = lineText.split(separator: ":")
//                    
//                    var potentialQualification = ""
//                    
//                    if lineTextSplit.count >= 2 {
//                        potentialQualification = String(lineTextSplit[1]).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                        
//                        let lineRightText = lineRight.Text.replacingOccurrences(of: ":", with: "")
//                        
//                        potentialQualification = lineRightText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    }
//                    
//                    QualificationParsed = true
//                    Model.Qualification = potentialQualification
//                    break search
//                }
//            }
//            
//            // Finding Date Approved
//            if !DateApprovedParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("approved"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    
//                    let lineTextSplit = lineText.split(separator: ":")
//                    
//                    var potentialDateApproved = ""
//                    
//                    if lineTextSplit.count >= 2 {
//                        potentialDateApproved = String(lineTextSplit[1])
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                        
//                        potentialDateApproved = lineRight.Text.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    }
//                    
//                    guard let date = potentialDateApproved.stringToDate(withFormat: "MMMMddyyyy") else { continue search }
//                    
//                    DateApprovedParsed = true
//                    Model.DateApproved = date
//                    break search
//                }
//            }
//            
//            // Finding Date Expiry
//            if !DateExpiryParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("expiry"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    
//                    let lineTextSplit = lineText.split(separator: ":")
//                    
//                    var potentialDateExpiry = ""
//                    
//                    if lineTextSplit.count >= 2 {
//                        potentialDateExpiry = String(lineTextSplit[1])
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                        
//                        potentialDateExpiry = lineRight.Text.replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    }
//                    
//                    guard let date = potentialDateExpiry.stringToDate(withFormat: "MMMMddyyyy") else { continue search }
//                    
//                    DateExpiryParsed = true
//                    Model.DateExpiry = date
//                    break search
//                }
//            }
//            
//            // Finding Other Licenses
//            if !OtherLicensesParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("otherlicenses"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replaceCommonCharactersWithLetters()
//                    
//                    let lineTextSplit = lineText.split(separator: ":")
//                    
//                    var potentialOtherLicenses = ""
//                    
//                    if lineTextSplit.count >= 2 {
//                        potentialOtherLicenses = String(lineTextSplit[1]).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                        
//                        let lineRightText = lineRight.Text.replacingOccurrences(of: ":", with: "")
//                        
//                        potentialOtherLicenses = lineRightText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    }
//                    
//                    OtherLicensesParsed = true
//                    Model.OtherLicenses = potentialOtherLicenses
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
//                    potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Left) {
//                        
//                        let lineBelowText = lineBelow.Text
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
//            frames = frames + 1
//        }
//        
//        if AreRequiredFrontTextFieldsParsed() || frames >= maxFrames || getCardTrys >= 6 {
//            success(Model)
//            Reset()
//        }
//        
//        getCardTrys = getCardTrys + 1
//    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        FullNameParsed = false
        LicenseToOwnAndPossessFirearmNumberParsed = false
        QualificationParsed = false
        DateApprovedParsed = false
        DateExpiryParsed = false
        OtherLicensesParsed = false
        AddressParsed = false
        Model = PhilippinesFirearmsLicenseModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return FullNameParsed && LicenseToOwnAndPossessFirearmNumberParsed && QualificationParsed && DateApprovedParsed && DateExpiryParsed && OtherLicensesParsed && AddressParsed
    }

}
