//
//  PhilippinesSeafarerIdentificationRecordBookParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

////import MLKit
import Sybrin_iOS_Common //import Sybrin.IOS.Common
import MLKitBarcodeScanning
import Foundation
import MLKitVision 
import MLKitFaceDetection 

struct PhilippinesSeafarerIdentificationRecordBookParser {
    
    // MARK: Private Properties
    private var FullNameParsed = false
    private var DateOfBirthParsed = false
    private var PlaceOfBirthParsed = false
    private var HeightParsed = false
    private var WeightParsed = false
    private var EyeColorParsed = false
    private var HairColorParsed = false
    private var DistinguishingMarksParsed = false
    private var SexParsed = false
    private var DateOfIssueParsed = false
    private var PlaceOfIssueParsed = false
    private var ValidUntilParsed = false
    private var DocumentNumberParsed = false
    private var Model = PhilippinesSeafarerIdentificationRecordBookModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isSIRBook = false
    var getCardTryes = 0
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesSeafarerIdentificationRecordBookModel) -> Void) {
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
//                return (itemText.contains("name"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.width * 2) else { continue search }
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
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("date") && itemText.contains("birth"))
//            }.flatMap { return $0.Elements }.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("date"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("place") && itemText.contains("birth"))
//                }
//                
//                for constraint in nextFieldConstraints {
//                    constraints.append((constraint, .Left))
//                }
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                
//                runningText = runningText.substring(to: 3) + runningText.substring(from: runningText.count - 6)
//                
//                guard let date = runningText.stringToDate(withFormat: "MMMddyyyy") else { continue search }
//                
//                guard date.isRealisticBirthDate else { continue search }
//                
//                DateOfBirthParsed = true
//                Model.DateOfBirth = date
//                break search
//            }
//        }
//        
//        // Finding Place Of Birth
//        if !PlaceOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("place") && itemText.contains("birth"))
//            }.flatMap { return $0.Elements }.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("place"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replaceCommonCharactersWithLetters()
//                
//                guard runningText.count >= 2 && runningText.count <= 40 else { continue search }
//                
//                PlaceOfBirthParsed = true
//                Model.PlaceOfBirth = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                break search
//            }
//        }
//        
//        // Finding Height
//        if !HeightParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("height"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//                
//                guard let height = Float(elementBelowText) else { continue search }
//                
//                HeightParsed = true
//                Model.Height = height
//                break search
//            }
//        }
//        
//        // Finding Weight
//        if !WeightParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("weight"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//                
//                guard let weight = Float(elementBelowText) else { continue search }
//                
//                WeightParsed = true
//                Model.Weight = weight
//                break search
//            }
//        }
//        
//        // Finding Eye Color
//        if !EyeColorParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("eyes"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                let nextFieldConstraints = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("hair"))
//                }
//                
//                for constraint in nextFieldConstraints {
//                    constraints.append((constraint, .Left))
//                }
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replaceCommonCharactersWithLetters()
//                
//                guard runningText.count >= 2 && runningText.count <= 10 else { continue search }
//                
//                EyeColorParsed = true
//                Model.EyeColor = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                break search
//            }
//        }
//        
//        // Finding Hair Color
//        if !HairColorParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("hair"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replaceCommonCharactersWithLetters()
//                
//                guard runningText.count >= 2 && runningText.count <= 10 else { continue search }
//                
//                HairColorParsed = true
//                Model.HairColor = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                break search
//            }
//        }
//        
//        // Finding Distinguishing Marks
//        if !DistinguishingMarksParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("distinguishingmarks"))
//            }.flatMap { return $0.Elements }.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("distinguishing"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                let nextFieldConstraints = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("sex"))
//                }
//                
//                for constraint in nextFieldConstraints {
//                    constraints.append((constraint, .Left))
//                }
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replaceCommonCharactersWithLetters()
//                
//                guard runningText.count >= 2 && runningText.count <= 60 else { continue search }
//                
//                DistinguishingMarksParsed = true
//                Model.DistinguishingMarks = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                break search
//            }
//        }
//        
//        // Finding Sex
//        if !SexParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("sex"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .InlineThreshold) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters().lowercased()
//                
//                guard elementBelowText == "m" || elementBelowText == "f" else { return }
//                
//                SexParsed = true
//                Model.Sex = (elementBelowText == "m") ? .Male : .Female
//            }
//        }
//        
//        // Finding Date Of Issue
//        if !DateOfIssueParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("date") && itemText.contains("issue"))
//            }.flatMap { return $0.Elements }.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("date"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 3) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("place") && itemText.contains("issue"))
//                }
//                
//                for constraint in nextFieldConstraints {
//                    constraints.append((constraint, .Left))
//                }
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                
//                runningText = runningText.substring(to: 3) + runningText.substring(from: runningText.count - 6)
//                
//                guard let date = runningText.stringToDate(withFormat: "MMMddyyyy") else { continue search }
//                
//                DateOfIssueParsed = true
//                Model.DateOfIssue = date
//                break search
//            }
//        }
//        
//        // Finding Place Of Issue
//        if !PlaceOfIssueParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("place") && itemText.contains("issue"))
//            }.flatMap { return $0.Elements }.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("place"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementToTheLeft = MLKitHelper.GetClosestItemToTheLeft(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width * 2, constraints: [(potentialMatch, .Below)]) else { continue search }
//                
//                var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                constraints.append((elementToTheLeft, .Right))
//                
//                let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("valid") && itemText.contains("until"))
//                }.flatMap { return $0.Elements }.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("valid"))
//                }
//                
//                for constraint in nextFieldConstraints {
//                    constraints.append((constraint, .Left))
//                }
//                
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width * 10, constraints: constraints) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replaceCommonCharactersWithLetters()
//                
//                guard runningText.count >= 2 && runningText.count <= 40 else { continue search }
//                
//                PlaceOfIssueParsed = true
//                Model.PlaceOfIssue = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                break search
//            }
//        }
//        
//        // Finding Valid Until
//        if !ValidUntilParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("valid") && itemText.contains("until"))
//            }.flatMap { return $0.Elements }.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("valid"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var runningText = ""
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 3) else { continue search }
//                
//                runningText += elementBelow.Text
//                
//                var comparingLine: ProtocolSybrinItem = elementBelow
//                while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width) {
//                    
//                    runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                    comparingLine = elementToTheRight
//                }
//                
//                guard runningText.count > 0 else { continue search }
//                
//                runningText = runningText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                
//                runningText = runningText.substring(to: 3) + runningText.substring(from: runningText.count - 6)
//                
//                guard let date = runningText.stringToDate(withFormat: "MMMddyyyy") else { continue search }
//                
//                ValidUntilParsed = true
//                Model.ValidUntil = date
//                break search
//            }
//        }
//        
//        // Finding Document Number
//        if !DocumentNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.lowercased().replacingOccurrences(of: " ", with: "")
//                return (RegexConstants.Philippines_Seaferer_Record_Book_Document_Number.matches(itemText))
//            }
//            
//            // Get physically biggest instance of Document Number
//            let potentailMatch = potentialMatches.max(by: { a, b in a.Frame.width < b.Frame.width })
//            
//            guard let potentailMatchString = potentailMatch?.Text else {
//                return
//            }
//            
//            DocumentNumberParsed = true
//            Model.DocumentNumber = potentailMatchString
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
//    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesSeafarerIdentificationRecordBookModel) -> Void) {
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
//        if !isSIRBook {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if (RegexConstants.Philippines_Seaferer_Record_Book_Document_Number.matches(itemText)) {
//                    isSIRBook = true
//                }
//                return (RegexConstants.Philippines_Seaferer_Record_Book_Document_Number.matches(itemText))
//            }
//        }
//        
//        if isSIRBook {
//            // Finding Full Name
//            if !FullNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("name"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.width * 2) else { continue search }
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
//            // Finding Date Of Birth
//            if !DateOfBirthParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("date") && itemText.contains("birth"))
//                }.flatMap { return $0.Elements }.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("date"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                    let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("place") && itemText.contains("birth"))
//                    }
//                    
//                    for constraint in nextFieldConstraints {
//                        constraints.append((constraint, .Left))
//                    }
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    
//                    runningText = runningText.substring(to: 3) + runningText.substring(from: runningText.count - 6)
//                    
//                    guard let date = runningText.stringToDate(withFormat: "MMMddyyyy") else { continue search }
//                    
//                    guard date.isRealisticBirthDate else { continue search }
//                    
//                    DateOfBirthParsed = true
//                    Model.DateOfBirth = date
//                    break search
//                }
//            }
//            
//            // Finding Place Of Birth
//            if !PlaceOfBirthParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("place") && itemText.contains("birth"))
//                }.flatMap { return $0.Elements }.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("place"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replaceCommonCharactersWithLetters()
//                    
//                    guard runningText.count >= 2 && runningText.count <= 40 else { continue search }
//                    
//                    PlaceOfBirthParsed = true
//                    Model.PlaceOfBirth = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    break search
//                }
//            }
//            
//            // Finding Height
//            if !HeightParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("height"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//                    
//                    guard let height = Float(elementBelowText) else { continue search }
//                    
//                    HeightParsed = true
//                    Model.Height = height
//                    break search
//                }
//            }
//            
//            // Finding Weight
//            if !WeightParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("weight"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//                    
//                    guard let weight = Float(elementBelowText) else { continue search }
//                    
//                    WeightParsed = true
//                    Model.Weight = weight
//                    break search
//                }
//            }
//            
//            // Finding Eye Color
//            if !EyeColorParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("eyes"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                    let nextFieldConstraints = sybrinItemGroup.Elements.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("hair"))
//                    }
//                    
//                    for constraint in nextFieldConstraints {
//                        constraints.append((constraint, .Left))
//                    }
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replaceCommonCharactersWithLetters()
//                    
//                    guard runningText.count >= 2 && runningText.count <= 10 else { continue search }
//                    
//                    EyeColorParsed = true
//                    Model.EyeColor = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    break search
//                }
//            }
//            
//            // Finding Hair Color
//            if !HairColorParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("hair"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replaceCommonCharactersWithLetters()
//                    
//                    guard runningText.count >= 2 && runningText.count <= 10 else { continue search }
//                    
//                    HairColorParsed = true
//                    Model.HairColor = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    break search
//                }
//            }
//            
//            // Finding Distinguishing Marks
//            if !DistinguishingMarksParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("distinguishingmarks"))
//                }.flatMap { return $0.Elements }.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("distinguishing"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 2) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                    let nextFieldConstraints = sybrinItemGroup.Elements.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("sex"))
//                    }
//                    
//                    for constraint in nextFieldConstraints {
//                        constraints.append((constraint, .Left))
//                    }
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replaceCommonCharactersWithLetters()
//                    
//                    guard runningText.count >= 2 && runningText.count <= 60 else { continue search }
//                    
//                    DistinguishingMarksParsed = true
//                    Model.DistinguishingMarks = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    break search
//                }
//            }
//            
//            // Finding Sex
//            if !SexParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("sex"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .InlineThreshold) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters().lowercased()
//                    
//                    guard elementBelowText == "m" || elementBelowText == "f" else { return }
//                    
//                    SexParsed = true
//                    Model.Sex = (elementBelowText == "m") ? .Male : .Female
//                }
//            }
//            
//            // Finding Date Of Issue
//            if !DateOfIssueParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("date") && itemText.contains("issue"))
//                }.flatMap { return $0.Elements }.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("date"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 3) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                    let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("place") && itemText.contains("issue"))
//                    }
//                    
//                    for constraint in nextFieldConstraints {
//                        constraints.append((constraint, .Left))
//                    }
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    
//                    runningText = runningText.substring(to: 3) + runningText.substring(from: runningText.count - 6)
//                    
//                    guard let date = runningText.stringToDate(withFormat: "MMMddyyyy") else { continue search }
//                    
//                    DateOfIssueParsed = true
//                    Model.DateOfIssue = date
//                    break search
//                }
//            }
//            
//            // Finding Place Of Issue
//            if !PlaceOfIssueParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("place") && itemText.contains("issue"))
//                }.flatMap { return $0.Elements }.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("place"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementToTheLeft = MLKitHelper.GetClosestItemToTheLeft(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width * 2, constraints: [(potentialMatch, .Below)]) else { continue search }
//                    
//                    var constraints: [(item: ProtocolSybrinItem, relative: RelativePosition)] = []
//                    constraints.append((elementToTheLeft, .Right))
//                    
//                    let nextFieldConstraints = sybrinItemGroup.Lines.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("valid") && itemText.contains("until"))
//                    }.flatMap { return $0.Elements }.filter { item in
//                        let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                        return (itemText.contains("valid"))
//                    }
//                    
//                    for constraint in nextFieldConstraints {
//                        constraints.append((constraint, .Left))
//                    }
//                    
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .InlineThreshold, threshold: potentialMatch.Frame.width * 10, constraints: constraints) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width, constraints: constraints) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replaceCommonCharactersWithLetters()
//                    
//                    guard runningText.count >= 2 && runningText.count <= 40 else { continue search }
//                    
//                    PlaceOfIssueParsed = true
//                    Model.PlaceOfIssue = runningText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    break search
//                }
//            }
//            
//            // Finding Valid Until
//            if !ValidUntilParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("valid") && itemText.contains("until"))
//                }.flatMap { return $0.Elements }.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("valid"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var runningText = ""
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left, threshold: potentialMatch.Frame.width * 3) else { continue search }
//                    
//                    runningText += elementBelow.Text
//                    
//                    var comparingLine: ProtocolSybrinItem = elementBelow
//                    while let elementToTheRight = MLKitHelper.GetClosestItemToTheRight(from: comparingLine, items: sybrinItemGroup.Elements, aligned: .Inline, threshold: comparingLine.Frame.width) {
//                        
//                        runningText = runningText.addWordToSentence(word: elementToTheRight.Text)
//
//                        comparingLine = elementToTheRight
//                    }
//                    
//                    guard runningText.count > 0 else { continue search }
//                    
//                    runningText = runningText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
//                    
//                    runningText = runningText.substring(to: 3) + runningText.substring(from: runningText.count - 6)
//                    
//                    guard let date = runningText.stringToDate(withFormat: "MMMddyyyy") else { continue search }
//                    
//                    ValidUntilParsed = true
//                    Model.ValidUntil = date
//                    break search
//                }
//            }
//            
//            // Finding Document Number
//            if !DocumentNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.lowercased().replacingOccurrences(of: " ", with: "")
//                    return (RegexConstants.Philippines_Seaferer_Record_Book_Document_Number.matches(itemText))
//                }
//                
//                // Get physically biggest instance of Document Number
//                let potentailMatch = potentialMatches.max(by: { a, b in a.Frame.width < b.Frame.width })
//                
//                guard let potentailMatchString = potentailMatch?.Text else {
//                    return
//                }
//                
//                DocumentNumberParsed = true
//                Model.DocumentNumber = potentailMatchString
//            }
//            
//            frames = frames + 1
//        }
//        
//        if AreRequiredFrontTextFieldsParsed() || frames >= maxFrames || getCardTryes >= 6{
//            success(Model)
//            Reset()
//        }
//        
//        getCardTryes = getCardTryes + 1
//        
//    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        FullNameParsed = false
        DateOfBirthParsed = false
        PlaceOfBirthParsed = false
        HeightParsed = false
        WeightParsed = false
        EyeColorParsed = false
        HairColorParsed = false
        DistinguishingMarksParsed = false
        SexParsed = false
        DateOfIssueParsed = false
        PlaceOfIssueParsed = false
        ValidUntilParsed = false
        DocumentNumberParsed = false
        Model = PhilippinesSeafarerIdentificationRecordBookModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return FullNameParsed && DateOfBirthParsed && PlaceOfBirthParsed && HeightParsed && WeightParsed && EyeColorParsed && HairColorParsed && DistinguishingMarksParsed && SexParsed && DateOfIssueParsed && PlaceOfIssueParsed && ValidUntilParsed && DocumentNumberParsed
    }

}
