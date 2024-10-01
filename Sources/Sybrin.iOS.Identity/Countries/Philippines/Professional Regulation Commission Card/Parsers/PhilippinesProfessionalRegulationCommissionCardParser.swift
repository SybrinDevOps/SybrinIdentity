//
//  PhilippinesProfessionalRegulationCommissionCardParser.swift
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

struct PhilippinesProfessionalRegulationCommissionCardParser {
    
    // MARK: Private Properties
    private var LastNameParsed = false
    private var FirstNameParsed = false
    private var MiddleInitialNameParsed = false
    private var RegistrationNumberParsed = false
    private var RegistrationDateParsed = false
    private var ValidUntilParsed = false
    private var ProfessionParsed = false
    private var DateOfBirthParsed = false
    private var DateIssuedParsed = false
    private var Model = PhilippinesProfessionalRegulationCommissionCardModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isPIDCard = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesProfessionalRegulationCommissionCardModel) -> Void) {
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
//        // Finding Last Name
//        if !LastNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("lastname"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var lineText = potentialMatch.Text.replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "")
//                
//                guard let nameIndex = lineText.lowercased().indexOf(str: "name"), nameIndex > -1 else { continue search }
//                
//                lineText = lineText.substring(from: nameIndex + 4).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                
//                var potentialLastName = ""
//                
//                if lineText.count > 0 {
//                    potentialLastName = lineText.replaceCommonCharactersWithLetters()
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                    
//                    potentialLastName = lineRight.Text.replaceCommonCharactersWithLetters()
//                }
//                
//                guard potentialLastName.count >= 2 && potentialLastName.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialLastName) else { continue search }
//                
//                LastNameParsed = true
//                Model.LastName = potentialLastName
//                break search
//            }
//        }
//        
//        // Finding First Name
//        if !FirstNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("firstname"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var lineText = potentialMatch.Text.replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "")
//                
//                guard let nameIndex = lineText.lowercased().indexOf(str: "name"), nameIndex > -1 else { continue search }
//                
//                lineText = lineText.substring(from: nameIndex + 4).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                
//                var potentialFirstName = ""
//                
//                if lineText.count > 0 {
//                    potentialFirstName = lineText.replaceCommonCharactersWithLetters()
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                    
//                    potentialFirstName = lineRight.Text.replaceCommonCharactersWithLetters()
//                }
//                
//                guard potentialFirstName.count >= 2 && potentialFirstName.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialFirstName) else { continue search }
//                
//                FirstNameParsed = true
//                Model.FirstName = potentialFirstName
//                break search
//            }
//        }
//        
//        // Finding Middle Initial Name
//        if !MiddleInitialNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("middle") && itemText.contains("name"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var lineText = potentialMatch.Text.replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "")
//                
//                guard let nameIndex = lineText.lowercased().indexOf(str: "name"), nameIndex > -1 else { continue search }
//                
//                lineText = lineText.substring(from: nameIndex + 4).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                
//                var potentialMiddleName = ""
//                
//                if lineText.count > 0 {
//                    potentialMiddleName = lineText.replaceCommonCharactersWithLetters()
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                    
//                    potentialMiddleName = lineRight.Text.replaceCommonCharactersWithLetters()
//                }
//                
//                guard potentialMiddleName.count >= 0 && potentialMiddleName.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(potentialMiddleName) else { continue search }
//                
//                MiddleInitialNameParsed = true
//                Model.MiddleInitialName = potentialMiddleName
//                break search
//            }
//        }
//        
//        // Finding Registration Number
//        if !RegistrationNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("registrationno"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "").lowercased()
//                
//                guard let registrationNoIndex = lineText.indexOf(str: "registrationno"), registrationNoIndex > -1 else { continue search }
//                
//                lineText = lineText.substring(from: registrationNoIndex + 14)
//                
//                var potentialRegistrationNumber = ""
//                
//                if lineText.count == 7 {
//                    potentialRegistrationNumber = lineText.replaceCommonCharactersWithNumbers()
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    potentialRegistrationNumber = lineRight.Text.replaceCommonCharactersWithNumbers()
//                }
//                
//                guard potentialRegistrationNumber.count == 7 else { continue search }
//                
//                guard RegexConstants.NumbersOnly.matches(potentialRegistrationNumber) else { continue search }
//                
//                RegistrationNumberParsed = true
//                Model.RegistrationNumber = potentialRegistrationNumber
//                break search
//            }
//        }
//        
//        // Finding Registration Date
//        if !RegistrationDateParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("registrationdate"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "").lowercased()
//                
//                guard let registrationDateIndex = lineText.indexOf(str: "registrationdate"), registrationDateIndex > -1 else { continue search }
//                
//                lineText = lineText.substring(from: registrationDateIndex + 16)
//                
//                var potentialRegistrationDate = ""
//                
//                if lineText.count >= 8 && lineText.count <= 10 {
//                    potentialRegistrationDate = lineText.replaceCommonCharactersWithNumbers()
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                    
//                    potentialRegistrationDate = lineRight.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithNumbers()
//                }
//                
//                guard potentialRegistrationDate.count >= 8 && potentialRegistrationDate.count <= 10 else { continue search }
//                
//                guard let date = potentialRegistrationDate.stringToDate(withFormat: "M/d/yyyy") else { continue search }
//                
//                RegistrationDateParsed = true
//                Model.RegistrationDate = date
//                break search
//            }
//        }
//        
//        var PreviousLineProcessed: ProtocolSybrinItem? = nil
//        
//        // Finding Valid Until
//        if !ValidUntilParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("valid") && itemText.contains("until"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "").lowercased()
//                
//                guard let validUntilIndex = lineText.indexOf(str: "validuntil"), validUntilIndex > -1 else { continue search }
//                
//                lineText = lineText.substring(from: validUntilIndex + 10)
//                
//                var potentialValidUntil = ""
//                
//                if lineText.count >= 8 && lineText.count <= 10 {
//                    potentialValidUntil = lineText.replaceCommonCharactersWithNumbers()
//                    PreviousLineProcessed = potentialMatch
//                } else {
//                    guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                    
//                    potentialValidUntil = lineRight.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithNumbers()
//                    PreviousLineProcessed = lineRight
//                }
//                
//                guard potentialValidUntil.count >= 8 && potentialValidUntil.count <= 10 else { continue search }
//                
//                guard let date = potentialValidUntil.stringToDate(withFormat: "M/d/yyyy") else { continue search }
//                
//                ValidUntilParsed = true
//                Model.ValidUntil = date
//                break search
//            }
//        }
//        
//        // Finding Profession
//        if !ProfessionParsed {
//            singleExecute: for _ in 0..<1 {
//                guard let previousLineProcessed = PreviousLineProcessed else { break singleExecute }
//                
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: previousLineProcessed, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: previousLineProcessed.Frame.width * 3) else { break singleExecute }
//                PreviousLineProcessed = nil
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { break singleExecute }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { break singleExecute }
//                
//                ProfessionParsed = true
//                Model.Profession = lineBelowText
//                PreviousLineProcessed = lineBelow
//            }
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            singleExecute: for _ in 0..<1 {
//                guard let previousLineProcessed = PreviousLineProcessed else { break singleExecute }
//                
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: previousLineProcessed, items: sybrinItemGroup.Lines, aligned: .Ignore, threshold: previousLineProcessed.Frame.width * 3) else { break singleExecute }
//                PreviousLineProcessed = nil
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithNumbers()
//                
//                guard lineBelowText.count >= 8 && lineBelowText.count <= 10 else { break singleExecute }
//                
//                if lineBelowText.contains("/") {
//                    guard let date = lineBelowText.stringToDate(withFormat: "M/d/yyyy") else { break singleExecute }
//                    
//                    guard date.isRealisticBirthDate else { break singleExecute }
//                    
//                    DateOfBirthParsed = true
//                    Model.DateOfBirth = date
//                    PreviousLineProcessed = lineBelow
//                } else {
//                    guard lineBelowText.count == 8 else { break singleExecute }
//                    
//                    guard let date = lineBelowText.stringToDate(withFormat: "MMddyyyy") else { break singleExecute }
//                    
//                    guard date.isRealisticBirthDate else { break singleExecute }
//                    
//                    DateOfBirthParsed = true
//                    Model.DateOfBirth = date
//                    PreviousLineProcessed = lineBelow
//                }
//            }
//        }
//        
//        // Finding Date Issued
//        if !DateIssuedParsed {
//            singleExecute: for _ in 0..<1 {
//                guard let previousLineProcessed = PreviousLineProcessed else { break singleExecute }
//                
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: previousLineProcessed, items: sybrinItemGroup.Lines, aligned: .Inline) else { break singleExecute }
//                PreviousLineProcessed = nil
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithNumbers()
//                
//                guard lineBelowText.count >= 8 && lineBelowText.count <= 10 else { break singleExecute }
//                
//                if lineBelowText.contains("/") {
//                    guard let date = lineBelowText.stringToDate(withFormat: "M/d/yyyy") else { break singleExecute }
//                    
//                    DateIssuedParsed = true
//                    Model.DateIssued = date
//                    PreviousLineProcessed = lineBelow
//                } else {
//                    guard lineBelowText.count == 8 else { break singleExecute }
//                    
//                    guard let date = lineBelowText.stringToDate(withFormat: "MMddyyyy") else { break singleExecute }
//                    
//                    DateIssuedParsed = true
//                    Model.DateIssued = date
//                    PreviousLineProcessed = lineBelow
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
    
    //MARK: - Partial Scans
    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesProfessionalRegulationCommissionCardModel) -> Void) {
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
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if (itemText.contains("professional")) {
//                    isPIDCard = true
//                }
//                return (itemText.contains("lastname"))
//            }
//        }
//        
//        if isPIDCard {
//            // Finding Last Name
//            if !LastNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("lastname"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var lineText = potentialMatch.Text.replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "")
//                    
//                    guard let nameIndex = lineText.lowercased().indexOf(str: "name"), nameIndex > -1 else { continue search }
//                    
//                    lineText = lineText.substring(from: nameIndex + 4).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    
//                    var potentialLastName = ""
//                    
//                    if lineText.count > 0 {
//                        potentialLastName = lineText.replaceCommonCharactersWithLetters()
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                        
//                        potentialLastName = lineRight.Text.replaceCommonCharactersWithLetters()
//                    }
//                    
//                    guard potentialLastName.count >= 2 && potentialLastName.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(potentialLastName) else { continue search }
//                    
//                    LastNameParsed = true
//                    Model.LastName = potentialLastName
//                    break search
//                }
//            }
//            
//            // Finding First Name
//            if !FirstNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("firstname"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var lineText = potentialMatch.Text.replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "")
//                    
//                    guard let nameIndex = lineText.lowercased().indexOf(str: "name"), nameIndex > -1 else { continue search }
//                    
//                    lineText = lineText.substring(from: nameIndex + 4).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    
//                    var potentialFirstName = ""
//                    
//                    if lineText.count > 0 {
//                        potentialFirstName = lineText.replaceCommonCharactersWithLetters()
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                        
//                        potentialFirstName = lineRight.Text.replaceCommonCharactersWithLetters()
//                    }
//                    
//                    guard potentialFirstName.count >= 2 && potentialFirstName.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(potentialFirstName) else { continue search }
//                    
//                    FirstNameParsed = true
//                    Model.FirstName = potentialFirstName
//                    break search
//                }
//            }
//            
//            // Finding Middle Initial Name
//            if !MiddleInitialNameParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("middle") && itemText.contains("name"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var lineText = potentialMatch.Text.replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "")
//                    
//                    guard let nameIndex = lineText.lowercased().indexOf(str: "name"), nameIndex > -1 else { continue search }
//                    
//                    lineText = lineText.substring(from: nameIndex + 4).trimmingCharacters(in: CharacterSet(charactersIn: " "))
//                    
//                    var potentialMiddleName = ""
//                    
//                    if lineText.count > 0 {
//                        potentialMiddleName = lineText.replaceCommonCharactersWithLetters()
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                        
//                        potentialMiddleName = lineRight.Text.replaceCommonCharactersWithLetters()
//                    }
//                    
//                    guard potentialMiddleName.count >= 0 && potentialMiddleName.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(potentialMiddleName) else { continue search }
//                    
//                    MiddleInitialNameParsed = true
//                    Model.MiddleInitialName = potentialMiddleName
//                    break search
//                }
//            }
//            
//            // Finding Registration Number
//            if !RegistrationNumberParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("registrationno"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "").lowercased()
//                    
//                    guard let registrationNoIndex = lineText.indexOf(str: "registrationno"), registrationNoIndex > -1 else { continue search }
//                    
//                    lineText = lineText.substring(from: registrationNoIndex + 14)
//                    
//                    var potentialRegistrationNumber = ""
//                    
//                    if lineText.count == 7 {
//                        potentialRegistrationNumber = lineText.replaceCommonCharactersWithNumbers()
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                        
//                        potentialRegistrationNumber = lineRight.Text.replaceCommonCharactersWithNumbers()
//                    }
//                    
//                    guard potentialRegistrationNumber.count == 7 else { continue search }
//                    
//                    guard RegexConstants.NumbersOnly.matches(potentialRegistrationNumber) else { continue search }
//                    
//                    RegistrationNumberParsed = true
//                    Model.RegistrationNumber = potentialRegistrationNumber
//                    break search
//                }
//            }
//            
//            // Finding Registration Date
//            if !RegistrationDateParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("registrationdate"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "").lowercased()
//                    
//                    guard let registrationDateIndex = lineText.indexOf(str: "registrationdate"), registrationDateIndex > -1 else { continue search }
//                    
//                    lineText = lineText.substring(from: registrationDateIndex + 16)
//                    
//                    var potentialRegistrationDate = ""
//                    
//                    if lineText.count >= 8 && lineText.count <= 10 {
//                        potentialRegistrationDate = lineText.replaceCommonCharactersWithNumbers()
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                        
//                        potentialRegistrationDate = lineRight.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithNumbers()
//                    }
//                    
//                    guard potentialRegistrationDate.count >= 8 && potentialRegistrationDate.count <= 10 else { continue search }
//                    
//                    guard let date = potentialRegistrationDate.stringToDate(withFormat: "M/d/yyyy") else { continue search }
//                    
//                    RegistrationDateParsed = true
//                    Model.RegistrationDate = date
//                    break search
//                }
//            }
//            
//            var PreviousLineProcessed: ProtocolSybrinItem? = nil
//            
//            // Finding Valid Until
//            if !ValidUntilParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("valid") && itemText.contains("until"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    var lineText = potentialMatch.Text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "►", with: "").replacingOccurrences(of: ">", with: "").lowercased()
//                    
//                    guard let validUntilIndex = lineText.indexOf(str: "validuntil"), validUntilIndex > -1 else { continue search }
//                    
//                    lineText = lineText.substring(from: validUntilIndex + 10)
//                    
//                    var potentialValidUntil = ""
//                    
//                    if lineText.count >= 8 && lineText.count <= 10 {
//                        potentialValidUntil = lineText.replaceCommonCharactersWithNumbers()
//                        PreviousLineProcessed = potentialMatch
//                    } else {
//                        guard let lineRight = MLKitHelper.GetClosestItemToTheRight(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: potentialMatch.Frame.height * 2) else { continue search }
//                        
//                        potentialValidUntil = lineRight.Text.replacingOccurrences(of: " ", with: "").replaceCommonCharactersWithNumbers()
//                        PreviousLineProcessed = lineRight
//                    }
//                    
//                    guard potentialValidUntil.count >= 8 && potentialValidUntil.count <= 10 else { continue search }
//                    
//                    guard let date = potentialValidUntil.stringToDate(withFormat: "M/d/yyyy") else { continue search }
//                    
//                    ValidUntilParsed = true
//                    Model.ValidUntil = date
//                    break search
//                }
//            }
//            
//            // Finding Profession
//            if !ProfessionParsed {
//                singleExecute: for _ in 0..<1 {
//                    guard let previousLineProcessed = PreviousLineProcessed else { break singleExecute }
//                    
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: previousLineProcessed, items: sybrinItemGroup.Lines, aligned: .Inline, threshold: previousLineProcessed.Frame.width * 3) else { break singleExecute }
//                    PreviousLineProcessed = nil
//                    
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { break singleExecute }
//                    
//                    guard RegexConstants.NoNumbers.matches(lineBelowText) else { break singleExecute }
//                    
//                    ProfessionParsed = true
//                    Model.Profession = lineBelowText
//                    PreviousLineProcessed = lineBelow
//                }
//            }
//            
//            // Finding Date Of Birth
//            if !DateOfBirthParsed {
//                singleExecute: for _ in 0..<1 {
//                    guard let previousLineProcessed = PreviousLineProcessed else { break singleExecute }
//                    
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: previousLineProcessed, items: sybrinItemGroup.Lines, aligned: .Ignore, threshold: previousLineProcessed.Frame.width * 3) else { break singleExecute }
//                    PreviousLineProcessed = nil
//                    
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithNumbers()
//                    
//                    guard lineBelowText.count >= 8 && lineBelowText.count <= 10 else { break singleExecute }
//                    
//                    if lineBelowText.contains("/") {
//                        guard let date = lineBelowText.stringToDate(withFormat: "M/d/yyyy") else { break singleExecute }
//                        
//                        guard date.isRealisticBirthDate else { break singleExecute }
//                        
//                        DateOfBirthParsed = true
//                        Model.DateOfBirth = date
//                        PreviousLineProcessed = lineBelow
//                    } else {
//                        guard lineBelowText.count == 8 else { break singleExecute }
//                        
//                        guard let date = lineBelowText.stringToDate(withFormat: "MMddyyyy") else { break singleExecute }
//                        
//                        guard date.isRealisticBirthDate else { break singleExecute }
//                        
//                        DateOfBirthParsed = true
//                        Model.DateOfBirth = date
//                        PreviousLineProcessed = lineBelow
//                    }
//                }
//                
//            }
//            
//            // Finding Date Issued
//            if !DateIssuedParsed {
//                singleExecute: for _ in 0..<1 {
//                    guard let previousLineProcessed = PreviousLineProcessed else { break singleExecute }
//                    
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: previousLineProcessed, items: sybrinItemGroup.Lines, aligned: .Inline) else { break singleExecute }
//                    PreviousLineProcessed = nil
//                    
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithNumbers()
//                    
//                    guard lineBelowText.count >= 8 && lineBelowText.count <= 10 else { break singleExecute }
//                    
//                    if lineBelowText.contains("/") {
//                        guard let date = lineBelowText.stringToDate(withFormat: "M/d/yyyy") else { break singleExecute }
//                        
//                        DateIssuedParsed = true
//                        Model.DateIssued = date
//                        PreviousLineProcessed = lineBelow
//                    } else {
//                        guard lineBelowText.count == 8 else { break singleExecute }
//                        
//                        guard let date = lineBelowText.stringToDate(withFormat: "MMddyyyy") else { break singleExecute }
//                        
//                        DateIssuedParsed = true
//                        Model.DateIssued = date
//                        PreviousLineProcessed = lineBelow
//                    }
//                }
//            }
//            
//            frames = frames + 1
//        }
//        
//        
//        
//        if AreRequiredFrontTextFieldsParsed() || frames >= maxFrames || getCardTrys >= 6{
//            success(Model)
//            Reset()
//        }
//        
//        getCardTrys = getCardTrys + 1
//        
//    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        LastNameParsed = false
        FirstNameParsed = false
        MiddleInitialNameParsed = false
        RegistrationNumberParsed = false
        RegistrationDateParsed = false
        ValidUntilParsed = false
        ProfessionParsed = false
        DateOfBirthParsed = false
        DateIssuedParsed = false
        Model = PhilippinesProfessionalRegulationCommissionCardModel()
    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return LastNameParsed && FirstNameParsed && MiddleInitialNameParsed && RegistrationNumberParsed && RegistrationDateParsed && ValidUntilParsed && ProfessionParsed
    }

}
