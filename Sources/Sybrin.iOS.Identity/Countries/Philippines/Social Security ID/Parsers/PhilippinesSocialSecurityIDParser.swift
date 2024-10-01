//
//  PhilippinesSocialSecurityIDParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin.IOS.Common
import MLKitBarcodeScanning
import Foundation
import MLKitVision 
import MLKitFaceDetection 

struct PhilippinesSocialSecurityIDParser {
    
    // MARK: Private Properties
    private var SocialSecurityNumberParsed = false
    private var FullNameParsed = false
    private var DateOfBirthParsed = false
    private var Model = PhilippinesSocialSecurityIDModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    
    var isSocialSecurity = false
    private var getCardTrys = 0
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesSocialSecurityIDModel) -> Void) {
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
//        
//        // Finding Social Security Number / Full Name / Date Of Birth
//        if !SocialSecurityNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithNumbers().lowercased().replacingOccurrences(of: " ", with: "")
//                return RegexConstants.Philippines_SocialSecurityNumber.matches(itemText)
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let lineText = potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: " ", with: "")
//                
//                guard RegexConstants.Philippines_SocialSecurityNumber.matches(lineText) else { continue search }
//
//                guard lineText.count == 12 else { continue search }
//                
//                SocialSecurityNumberParsed = true
//                Model.SocialSecurityNumber = lineText
//                
//                var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("social") && itemText.contains("security") && itemText.contains("system"))
//                }
//                
//                for constraint in nextFieldConstraints {
//                    constraints.append((constraint, .Below))
//                }
//                
//                guard constraints.count > 0 else { continue search }
//                
//                var names = ""
//                var lineAbove = MLKitHelper.GetClosestItemAbove(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.width * 3, constraints: constraints)
//                guard lineAbove != nil else { continue search }
//                
//                namesSearch: repeat {
//                    let lineAboveText = lineAbove!.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard lineAboveText.count >= 2 && lineAboveText.count <= 40 else { break namesSearch }
//                    
//                    guard RegexConstants.NoNumbers.matches(lineAboveText) else { break namesSearch }
//                    
//                    if names.count > 0 {
//                        names = " " + names
//                    }
//                    
//                    names = lineAboveText + names
//                    
//                    lineAbove = MLKitHelper.GetClosestItemAbove(from: lineAbove!, items: sybrinItemGroup.Lines, aligned: .Inline)
//                } while lineAbove != nil
//                
//                guard names.count > 0 else { continue search }
//                
//                FullNameParsed = true
//                Model.FullName = names.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                
//                guard let date = lineBelowText.stringToDate(withFormat: "MMMMddyyyy") else { continue search }
//                
//                guard date.isRealisticBirthDate else { continue search }
//                
//                DateOfBirthParsed = true
//                Model.DateOfBirth = date
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
//    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesSocialSecurityIDModel) -> Void) {
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
//        // Finding Social Security Number / Full Name / Date Of Birth
//        
//        if !isSocialSecurity {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if (itemText.contains("social") && itemText.contains("security") && itemText.contains("system")) {
//                    isSocialSecurity = true
//                }
//                
//                return (itemText.contains("social") && itemText.contains("security") && itemText.contains("system"))
//            }
//        }
//        
//        if isSocialSecurity {
//            if !SocialSecurityNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithNumbers().lowercased().replacingOccurrences(of: " ", with: "")
//                    return RegexConstants.Philippines_SocialSecurityNumber.matches(itemText)
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    let lineText = potentialMatch.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: " ", with: "")
//                    
//                    guard RegexConstants.Philippines_SocialSecurityNumber.matches(lineText) else { continue search }
//
//                    guard lineText.count == 12 else { continue search }
//                    
//                    SocialSecurityNumberParsed = true
//                    Model.SocialSecurityNumber = lineText
//                    
//                    var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                    let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("social") && itemText.contains("security") && itemText.contains("system"))
//                    }
//                    
//                    for constraint in nextFieldConstraints {
//                        constraints.append((constraint, .Below))
//                    }
//                    
//                    guard constraints.count > 0 else { continue search }
//                    
//                    var names = ""
//                    var lineAbove = MLKitHelper.GetClosestItemAbove(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.width * 3, constraints: constraints)
//                    guard lineAbove != nil else { continue search }
//                    
//                    namesSearch: repeat {
//                        let lineAboveText = lineAbove!.Text.replaceCommonCharactersWithLetters()
//                        
//                        guard lineAboveText.count >= 2 && lineAboveText.count <= 40 else { break namesSearch }
//                        
//                        guard RegexConstants.NoNumbers.matches(lineAboveText) else { break namesSearch }
//                        
//                        if names.count > 0 {
//                            names = " " + names
//                        }
//                        
//                        names = lineAboveText + names
//                        
//                        lineAbove = MLKitHelper.GetClosestItemAbove(from: lineAbove!, items: sybrinItemGroup.Lines, aligned: .Inline)
//                    } while lineAbove != nil
//                    
//                    guard names.count > 0 else { continue search }
//                    
//                    FullNameParsed = true
//                    Model.FullName = names.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                    
//                    let lineBelowText = lineBelow.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                    
//                    guard let date = lineBelowText.stringToDate(withFormat: "MMMMddyyyy") else { continue search }
//                    
//                    guard date.isRealisticBirthDate else { continue search }
//                    
//                    DateOfBirthParsed = true
//                    Model.DateOfBirth = date
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
        SocialSecurityNumberParsed = false
        FullNameParsed = false
        DateOfBirthParsed = false
        Model = PhilippinesSocialSecurityIDModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return SocialSecurityNumberParsed && FullNameParsed
    }

}
