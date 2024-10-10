//
//  SouthAfricaGreenBookParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import MLKitFaceDetection 
import Foundation

struct SouthAfricaGreenBookParser {
    
    // MARK: Private Properties
    private var IdentityNumberParsed = false
    private var SurnameParsed = false
    private var FirstNamesParsed = false
    private var CountryOfBirthParsed = false
    private var DateOfBirthParsed = false
    private var DateIssuedParsed = false
    private var Model = SouthAfricaGreenBookModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: SouthAfricaGreenBookModel) -> Void) {
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
//        // Finding Green Book Type
//        if (Model.bookType == .Unspecified) {
//            let resultText = result.text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//            if resultText.contains("van/surname") || resultText.contains("voorname") || resultText.contains("geboorte") || resultText.contains("datum") || resultText.contains("distrik") || resultText.contains("uitgereik") {
//                Model.BookType = .Bilingual
//            } else if resultText.contains("surname") || resultText.contains("forenames") || resultText.contains("country") || resultText.contains("birth") || resultText.contains("date") || resultText.contains("issued") {
//                Model.BookType = .English
//            }
//        }
//        
//        // Finding Identity Number
//        if !IdentityNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "l", with: "i")
//                return (itemText.contains("idno") && itemText.count == 17)
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                let potentialIdentityNumber = potentialMatch.Text.replacingOccurrences(of: " ", with: "").suffix(13).replaceCommonCharactersWithNumbers()
//                
//                guard RegexConstants.SouthAfrica_IdentityNumber.matches(potentialIdentityNumber) else { continue search }
//                
//                guard let identityNumber = SouthAfricaIdentityNumberParser.ParseIdentityNumber(potentialIdentityNumber) else { continue search }
//                
//                if DateOfBirthParsed {
//                    guard Model.DateOfBirth == identityNumber.DateOfBirth else { continue search }
//                }
//                
//                IdentityNumberParsed = true
//                Model.SouthAfricaIdentityNumber = identityNumber
//                break search
//            }
//        }
//        
//        // Finding Surname
//        if !SurnameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("van/surname") || itemText.contains("surname"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 3 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                SurnameParsed = true
//                Model.Surname = lineBelowText
//                break search
//            }
//        }
//        
//        // Finding First Names
//        if !FirstNamesParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("voorname") || itemText.contains("forenames"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 3 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                FirstNamesParsed = true
//                Model.FirstNames = lineBelowText
//                break search
//            }
//        }
//        
//        // Finding Country Of Birth
//        if !CountryOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("country") && itemText.contains("birth"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 3 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                CountryOfBirthParsed = true
//                Model.CountryOfBirth = lineBelowText
//                break search
//            }
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            switch Model.BookType {
//                case .Bilingual:
//                    let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("datum") && itemText.contains("uitgereik"))
//                    }.flatMap { $0.Elements }
//                    
//                    search: for potentialMatch in potentialMatches {
//                        guard let elementAbove = MLKitHelper.GetClosestItemAbove(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                        
//                        let elementAboveText = elementAbove.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "-", with: "")
//                        
//                        guard elementAboveText.count == 8 else { continue search }
//                        
//                        guard let dateOfBirth = elementAboveText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                        
//                        guard dateOfBirth.isRealisticBirthDate else { continue search }
//                        
//                        if IdentityNumberParsed {
//                            guard Model.identityNumberDateOfBirth == dateOfBirth else { continue search }
//                        }
//
//                        DateOfBirthParsed = true
//                        Model.DateOfBirth = dateOfBirth
//                        break search
//                    }
//                case .English:
//                    let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("date") && itemText.contains("birth"))
//                    }.flatMap { $0.Elements }
//                    
//                    search: for potentialMatch in potentialMatches {
//                        guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                        
//                        let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "-", with: "")
//
//                        guard elementBelowText.count == 8 else { continue search }
//
//                        guard let dateOfBirth = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                        
//                        if IdentityNumberParsed {
//                            guard Model.identityNumberDateOfBirth == dateOfBirth else { continue search }
//                        }
//
//                        DateOfBirthParsed = true
//                        Model.DateOfBirth = dateOfBirth
//                        break search
//                    }
//                case .Unspecified: break
//            }
//        }
//        
//        // Finding Date Issued
//        if !DateIssuedParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("date") && itemText.contains("issued"))
//            }.flatMap { $0.Elements }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "-", with: "")
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
//        if AreRequiredFieldsParsed() {
//            success(Model)
//            Reset()
//        }
//        
//    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        IdentityNumberParsed = false
        SurnameParsed = false
        FirstNamesParsed = false
        CountryOfBirthParsed = false
        DateOfBirthParsed = false
        DateIssuedParsed = false
        Model = SouthAfricaGreenBookModel()
    }
    
    private func AreRequiredFieldsParsed() -> Bool {
        return IdentityNumberParsed && SurnameParsed && FirstNamesParsed && CountryOfBirthParsed && DateOfBirthParsed && DateIssuedParsed
    }

}
