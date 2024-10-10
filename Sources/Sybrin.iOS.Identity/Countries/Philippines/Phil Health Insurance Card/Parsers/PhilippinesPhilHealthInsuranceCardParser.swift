//
//  PhilippinesPhilHealthInsuranceCardParser.swift
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

struct PhilippinesPhilHealthInsuranceCardParser {
    
    // MARK: Private Properties
    private var PhilHealthNumberParsed = false
    private var PhilHealthLine: ProtocolSybrinItem? = nil
    private var FullNameParsed = false
    private var FullNameLine: ProtocolSybrinItem? = nil
    private var DateOfBirthParsed = false
    private var SexParsed = false
    private var DateOfBirthAndSexLine: ProtocolSybrinItem? = nil
    private var AddressParsed = false
    private var Model = PhilippinesPhilHealthInsuranceCardModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isPHICard = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesPhilHealthInsuranceCardModel) -> Void) {
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
//        // Finding Phil Health Number
//        if !PhilHealthNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithNumbers().lowercased().replacingOccurrences(of: " ", with: "")
//                return RegexConstants.Philippines_PhilHealthNumber.matches(itemText)
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: " ", with: "")
//                
//                guard RegexConstants.Philippines_PhilHealthNumber.matches(lineText) else { continue search }
//
//                guard lineText.count == 14 else { continue search }
//                
//                PhilHealthNumberParsed = true
//                Model.PhilHealthNumber = lineText
//                PhilHealthLine = potentialMatch
//                break search
//            }
//        }
//        
//        // Finding Full Name
//        if !FullNameParsed {
//            guard let philHealthLine = PhilHealthLine else { return }
//            
//            guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: philHealthLine, items: sybrinItemGroup.Lines, aligned: .Left) else { return }
//            
//            let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//            
//            guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { return }
//            
//            guard RegexConstants.NoNumbers.matches(lineBelowText) else { return }
//            
//            FullNameParsed = true
//            Model.FullName = lineBelowText
//            FullNameLine = lineBelow
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            guard let fullNameLine = FullNameLine else { return }
//            
//            guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: fullNameLine, items: sybrinItemGroup.Lines, aligned: .Left, threshold: fullNameLine.Frame.width * 3) else { return }
//            
//            var lineBelowText = lineBelow.Text.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//            
//            guard let firstSpaceIndex = lineBelowText.indexOf(str: " "), firstSpaceIndex > -1 else { return }
//            
//            lineBelowText = lineBelowText.substring(to: 3) + lineBelowText.substring(from: firstSpaceIndex)
//            
//            lineBelowText = lineBelowText.replacingOccurrences(of: " ", with: "")
//            
//            let lineBelowTextSplit = lineBelowText.split(separator: "-")
//            
//            guard lineBelowTextSplit.count >= 1 else { return }
//            
//            guard lineBelowTextSplit[0].count == 9 else { return }
//            
//            guard let date = String(lineBelowTextSplit[0]).stringToDate(withFormat: "MMMddyyyy") else { return }
//            
//            guard date.isRealisticBirthDate else { return }
//            
//            DateOfBirthParsed = true
//            Model.DateOfBirth = date
//            DateOfBirthAndSexLine = lineBelow
//        }
//        
//        // Finding Sex
//        if !SexParsed {
//            guard let fullNameLine = FullNameLine else { return }
//            
//            guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: fullNameLine, items: sybrinItemGroup.Lines, aligned: .Left, threshold: fullNameLine.Frame.width * 3) else { return }
//            
//            let lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//            
//            let lineBelowTextSplit = lineBelowText.split(separator: "-")
//            
//            guard lineBelowTextSplit.count >= 2 else { return }
//            
//            guard lineBelowTextSplit[1].count > 0 else { return }
//            
//            let potentialSex = lineBelowTextSplit[1].replaceCommonCharactersWithLetters().lowercased()
//            
//            guard potentialSex == "male" || potentialSex == "female" else { return }
//            
//            SexParsed = true
//            Model.Sex = (potentialSex == "male") ? .Male : .Female
//            DateOfBirthAndSexLine = lineBelow
//        }
//        
//        // Finding Address
//        if !AddressParsed {
//            guard let dateOfBirthAndSexLine = DateOfBirthAndSexLine else { return }
//            
//            var address = ""
//            var comparingLine: ProtocolSybrinItem = dateOfBirthAndSexLine
//            potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Left) {
//                
//                let lineBelowText = lineBelow.Text
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 45 else { break potentialLine }
//                
//                address += "\((address.count > 0) ? "\n" : "")\(lineBelowText)"
//
//                comparingLine = lineBelow
//            }
//            
//            if address.count > 0 {
//                AddressParsed = true
//                Model.Address = address
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
    // MARK: - Partial Scan
    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesPhilHealthInsuranceCardModel) -> Void) {
//        
//        let model = PhilippinesPhilHealthInsuranceCardModel()
//        // Resetting model if needed
//        resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//
//            //Reset()
//        }
//        
//        let sybrinItemGroup = MLKitHelper.BlocksToSybrinItemGroup(result.blocks)
//        
//        
//        if !isPHICard {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if itemText.contains("philhealth") || itemText.contains("health"){
//                    isPHICard = true
//                }
//                
//                return itemText.contains("philhealth") || itemText.contains("health")
//            }
//        }
//        
//        
//        if isPHICard {
//            // Finding Phil Health Number
//            if !PhilHealthNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithNumbers().lowercased().replacingOccurrences(of: " ", with: "")
//                    return RegexConstants.Philippines_PhilHealthNumber.matches(itemText)
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: " ", with: "")
//                    
//                    guard RegexConstants.Philippines_PhilHealthNumber.matches(lineText) else { continue search }
//
//                    guard lineText.count == 14 else { continue search }
//                    
//                    PhilHealthNumberParsed = true
//                    model.PhilHealthNumber = lineText
//                    PhilHealthLine = potentialMatch
//                    break search
//                }
//            }
//            
//            // Finding Full Name
//            if !FullNameParsed {
//                guard let philHealthLine = PhilHealthLine else { return }
//                
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: philHealthLine, items: sybrinItemGroup.Lines, aligned: .Left) else { return }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { return }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { return }
//                
//                FullNameParsed = true
//                model.FullName = lineBelowText
//                FullNameLine = lineBelow
//            }
//            
//            // Finding Date Of Birth
//            if !DateOfBirthParsed {
////                guard let fullNameLine = FullNameLine else { return }
////
////                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: fullNameLine, items: sybrinItemGroup.Lines, aligned: .Left, threshold: fullNameLine.Frame.width * 3) else { return }
////
////                var lineBelowText = lineBelow.Text.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
////
////                guard let firstSpaceIndex = lineBelowText.indexOf(str: " "), firstSpaceIndex > -1 else { return }
////
////                lineBelowText = lineBelowText.substring(to: 3) + lineBelowText.substring(from: firstSpaceIndex)
////
////                lineBelowText = lineBelowText.replacingOccurrences(of: " ", with: "")
////
////                let lineBelowTextSplit = lineBelowText.split(separator: "-")
////
////                guard lineBelowTextSplit.count >= 1 else { return }
////
////                guard lineBelowTextSplit[0].count == 9 else { return }
//                
////                guard let date = String(lineBelowTextSplit[0]).stringToDate(withFormat: "MMMddyyyy") else { return }
////
////                guard date.isRealisticBirthDate else { return }
////
////                DateOfBirthParsed = true
////                model.DateOfBirth = date
////                DateOfBirthAndSexLine = lineBelow
//            }
//            
//            // Finding Sex
//            if !SexParsed {
////                guard let fullNameLine = FullNameLine else { return }
////
////                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: fullNameLine, items: sybrinItemGroup.Lines, aligned: .Left, threshold: fullNameLine.Frame.width * 3) else { return }
////
////                let lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
////
////                let lineBelowTextSplit = lineBelowText.split(separator: "-")
////
////                guard lineBelowTextSplit.count >= 2 else { return }
////
////                guard lineBelowTextSplit[1].count > 0 else { return }
////
////                let potentialSex = lineBelowTextSplit[1].replaceCommonCharactersWithLetters().lowercased()
////
////                guard potentialSex == "male" || potentialSex == "female" else { return }
////
////                SexParsed = true
////                model.Sex = (potentialSex == "male") ? .Male : .Female
////                DateOfBirthAndSexLine = lineBelow
//            }
//            
//            // Finding Address
//            if !AddressParsed {
////                guard let dateOfBirthAndSexLine = DateOfBirthAndSexLine else { return }
////
////                var address = ""
////                var comparingLine: ProtocolSybrinItem = dateOfBirthAndSexLine
////                potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Left) {
////
////                    let lineBelowText = lineBelow.Text
////
////                    guard lineBelowText.count >= 2 && lineBelowText.count <= 45 else { break potentialLine }
////
////                    address += "\((address.count > 0) ? "\n" : "")\(lineBelowText)"
////
////                    comparingLine = lineBelow
////                }
////
////                if address.count > 0 {
////                    AddressParsed = true
////                    model.Address = address
////                }
//            }
//            
//            frames = frames + 1
//        }
//        
//        if AreRequiredFrontTextFieldsParsed() || frames >= maxFrames || getCardTrys >= 6{
//            success(model)
//            Reset()
//        }
//        
//        getCardTrys = getCardTrys + 1
//        
//                
//    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        PhilHealthNumberParsed = false
        PhilHealthLine = nil
        FullNameParsed = false
        FullNameLine = nil
        DateOfBirthParsed = false
        SexParsed = false
        DateOfBirthAndSexLine = nil
        AddressParsed = false
        Model = PhilippinesPhilHealthInsuranceCardModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return PhilHealthNumberParsed && FullNameParsed && DateOfBirthParsed && SexParsed && AddressParsed
    }

}
