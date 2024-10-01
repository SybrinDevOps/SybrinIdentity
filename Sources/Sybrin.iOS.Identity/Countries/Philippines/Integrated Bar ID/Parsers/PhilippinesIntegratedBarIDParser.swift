//
//  PhilippinesIntegratedBarIDParser.swift
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

struct PhilippinesIntegratedBarIDParser {
    
    // MARK: Private Properties
    private var FullNameParsed = false
    private var RollOfAttorneysNumberParsed = false
    private var IntegratedBarPhilippinesChapterParsed = false
    private var Model = PhilippinesIntegratedBarIDModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isIBDIDcard = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesIntegratedBarIDModel) -> Void) {
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
//                return (itemText.contains("rollofattorneysno"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineAbove = MLKitHelper.GetClosestItemAbove(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Right, threshold: potentialMatch.Frame.width * 3) else { continue search }
//                
//                let lineAboveText = lineAbove.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineAboveText.count >= 2 && lineAboveText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineAboveText) else { continue search }
//                
//                FullNameParsed = true
//                Model.FullName = lineAboveText
//                break search
//            }
//        }
//        
//        // Finding Roll Of Attorneys Number
//        if !RollOfAttorneysNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("rollofattorneysno"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Right) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithNumbers()
//                
//                guard lineBelowText.count == 5 else { continue search }
//                
//                guard RegexConstants.NumbersOnly.matches(lineBelowText) else { continue search }
//                
//                RollOfAttorneysNumberParsed = true
//                Model.RollOfAttorneysNumber = lineBelowText
//                break search
//            }
//        }
//        
//        // Finding Integrated Bar Philippines Chapter
//        if !IntegratedBarPhilippinesChapterParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("ibpchapter"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Right) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                IntegratedBarPhilippinesChapterParsed = true
//                Model.IntegratedBarPhilippinesChapter = lineBelowText
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
//    // MARK: - Partial Scan
//    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesIntegratedBarIDModel) -> Void) {
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
//        if !isIBDIDcard {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if itemText.contains("integrated") || itemText.contains("ibp") {
//                    isIBDIDcard = true
//                }
//                return itemText.contains("integrated") || itemText.contains("ibp")
//            }
//        }
//        
//        if isIBDIDcard {
//            // Finding Full Name
//            if !FullNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("rollofattorneysno"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineAbove = MLKitHelper.GetClosestItemAbove(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Right, threshold: potentialMatch.Frame.width * 3) else { continue search }
//                    
//                    let lineAboveText = lineAbove.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard lineAboveText.count >= 2 && lineAboveText.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(lineAboveText) else { continue search }
//                    
//                    FullNameParsed = true
//                    Model.FullName = lineAboveText
//                    break search
//                }
//            }
//            
//            // Finding Roll Of Attorneys Number
//            if !RollOfAttorneysNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("rollofattorneysno"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Right) else { continue search }
//                    
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithNumbers()
//                    
//                    guard lineBelowText.count == 5 else { continue search }
//                    
//                    guard RegexConstants.NumbersOnly.matches(lineBelowText) else { continue search }
//                    
//                    RollOfAttorneysNumberParsed = true
//                    Model.RollOfAttorneysNumber = lineBelowText
//                    break search
//                }
//            }
//            
//            // Finding Integrated Bar Philippines Chapter
//            if !IntegratedBarPhilippinesChapterParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("ibpchapter"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Right) else { continue search }
//                    
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                    
//                    IntegratedBarPhilippinesChapterParsed = true
//                    Model.IntegratedBarPhilippinesChapter = lineBelowText
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
//    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        FullNameParsed = false
        RollOfAttorneysNumberParsed = false
        IntegratedBarPhilippinesChapterParsed = false
        Model = PhilippinesIntegratedBarIDModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return FullNameParsed && RollOfAttorneysNumberParsed && IntegratedBarPhilippinesChapterParsed
    }

}
