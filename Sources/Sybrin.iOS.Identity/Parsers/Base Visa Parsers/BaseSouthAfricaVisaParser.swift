//
//  BaseVisaParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/01.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
import MLKitFaceDetection  ////import MLKit
import MLKitVision 
import Foundation

class BaseSouthAfricaVisaParser {
    
    // Initialization
    init(title: String?) {
        self.Title = title
    }
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: Internal Properties
    var Title: String?
    
    var Model: BaseSouthAfricaVisaModel = BaseSouthAfricaVisaModel()
    var TitleParsed: Bool = false
    var NamesParsed: Bool = false
    var PassportNumberParsed: Bool = false;
    var NumberOfEntriesParsed: Bool = false
    var ValidFromParsed: Bool = false
    var ReferenceNumberParsed: Bool = false
    var DateOfExpiryParsed: Bool = false
    var IssuedAtParsed: Bool = false
    var ControlNumberParsed: Bool = false
    
    var IsAllParsed: Bool {
        return TitleParsed && NamesParsed && PassportNumberParsed && NumberOfEntriesParsed && ValidFromParsed && ReferenceNumberParsed && DateOfExpiryParsed && IssuedAtParsed && ControlNumberParsed
    }
    
//    func ParseText(from result: Text) {
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
//        // Finding Title
//        if !TitleParsed {
//            guard let title = Title else {
//                return
//            }
//            
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains(title.replacingOccurrences(of: " ", with: "").lowercased()))
//            }
//            
//            if potentialMatches.count == 1 {
//                TitleParsed = true
//            }
//        }
        
//        parseNames(from: sybrinItemGroup)
//        parsePassportNumber(from: sybrinItemGroup)
//        parseNumberOfEntries(from: sybrinItemGroup)
//        parseIssuedAt(from: sybrinItemGroup)
//        parseControlNumber(from: sybrinItemGroup)
//        parseReferenceNumber(from: sybrinItemGroup)
//        parseDateOfExpiry(from: sybrinItemGroup)
//        parseValidFrom(from: sybrinItemGroup)
//    }
    
    // MARK: Parse Methods
    
    // Finding Names
    func parseNames(from sybrinItemGroup: SybrinItemGroup){
        if !NamesParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("name"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Name": "","name": "","NAME": "", ": ": "", "; ": ""]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.replaceCommonCharactersWithLetters().trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard cleanedPotentialMatch.count >= 3 && cleanedPotentialMatch.count <= 40 else { continue search }
                
                guard RegexConstants.NoNumbers.matches(cleanedPotentialMatch) else { continue search }
                
                NamesParsed = true
                Model.Names = cleanedPotentialMatch
                break search
            }
        }
    }
    
    // Finding Passport Number
    func parsePassportNumber(from sybrinItemGroup: SybrinItemGroup){
        if !PassportNumberParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("passportno"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Passport": "","passport": "","PASSPORT": "", ":": "", ";": "", "No": "", "no": "", "NO": "", "Na": "" , "na": "" , "NA": "", " ": ""]
                let cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                guard cleanedPotentialMatch.count == 9 else { continue search }
                
                guard RegexConstants.AlphaNumeric.matches(cleanedPotentialMatch) else { continue search }
                
                PassportNumberParsed = true
                Model.PassportNumber = cleanedPotentialMatch
                break search
            }
        }
    }
    
    // Finding Number of Entries
    func parseNumberOfEntries(from sybrinItemGroup: SybrinItemGroup){
        if !NumberOfEntriesParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("entries"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Entries": "","entries": "","ENTRIES": "", ": ": "", "; ": "" , ". " : "" , "," : "" , "No": "" , "no": "" , "NO": "", "Na": "" , "na": "" , "NA": "", "Of": "" , "of": "" , "OF": ""]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.replaceCommonCharactersWithLetters().trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard cleanedPotentialMatch.count >= 3 && cleanedPotentialMatch.count <= 40 else { continue search }
                
                guard RegexConstants.NoNumbers.matches(cleanedPotentialMatch) else { continue search }
                
                NumberOfEntriesParsed = true
                Model.NumberOfEntries = cleanedPotentialMatch
                break search
            }
        }
    }
    
    // Finding Issued At
    func parseIssuedAt(from sybrinItemGroup: SybrinItemGroup){
        if !IssuedAtParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("issuedat"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Issued": "","issued": "","ISSUED": "", ": ": "", "; ": "" , ". " : "" , "," : "" , "At": "" , "at": "" , "AT": ""]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.replaceCommonCharactersWithLetters().trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard cleanedPotentialMatch.count >= 3 && cleanedPotentialMatch.count <= 40 else { continue search }
                
                guard RegexConstants.NoNumbers.matches(cleanedPotentialMatch) else { continue search }
                
                IssuedAtParsed = true
                Model.IssuedAt = cleanedPotentialMatch
                break search
            }
        }
    }
    
    // Finding Control Number
    func parseControlNumber(from sybrinItemGroup: SybrinItemGroup){
        if !ControlNumberParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("controlno"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Control": "","control": "","CONTROL": "", ": ": "", "; ": "" , ". " : "" , ", " : "", ":": "", ";": "" , "." : "" , "," : "","No": "" , "no": "" , "NO": "", "Na": "" , "na": "" , "NA": "",]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard cleanedPotentialMatch.count >= 3 && cleanedPotentialMatch.count <= 40 else { continue search }
                
                guard RegexConstants.AlphaNumeric.matches(cleanedPotentialMatch) else { continue search }
                
                ControlNumberParsed = true
                Model.ControlNumber = cleanedPotentialMatch
                break search
            }
        }
    }
    
    // Finding Reference Number
    func parseReferenceNumber(from sybrinItemGroup: SybrinItemGroup){
        if !ReferenceNumberParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("refno"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Ref": "","ref": "","REF": "", ": ": "", "; ": "" , ". " : "" , "," : "", "No": "" , "no": "" , "NO": "", "Na": "" , "na": "" , "NA": "",]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard cleanedPotentialMatch.count == 18 else { continue search }
                
                guard RegexConstants.SouthAfrica_Visa_Reference_Number.matches(cleanedPotentialMatch) else { continue search }
                
                ReferenceNumberParsed = true
                Model.ReferenceNumber = cleanedPotentialMatch
                break search
            }
        }
    }
    
    // Finding Date of Expiry
//    func parseDateOfExpiry(from sybrinItemGroup: SybrinItemGroup){
//        if !DateOfExpiryParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("expirydate"))
//            }.flatMap { $0.Elements }
//            
//            search: for potentialMatch in potentialMatches {
//                
//                let bagOfWords = ["Visa": "","visa": "","VISA": "","Expiry": "","expiry": "","EXPIRY": "", ": ": "", "; ": "" , ". " : "" , "," : "", "Date": "" , "date": "" , "DATE": ""]
//                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
//                
//                cleanedPotentialMatch = cleanedPotentialMatch.trimmingCharacters(in: .whitespacesAndNewlines).replaceCommonCharactersWithNumbers().replacingOccurrences(of: "-", with: "")
//                
//                guard cleanedPotentialMatch.count == 8 else { continue search }
//                
//                guard let dateOfExpiry = cleanedPotentialMatch.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                
//                DateOfExpiryParsed = true
//                Model.DateOfExpiry = dateOfExpiry
//                break search
//            }
//        }
//    }
    
    // Finding Valid From
    func parseValidFrom(from sybrinItemGroup: SybrinItemGroup){
        if !ValidFromParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("validfrom"))
            }.flatMap { $0.Elements }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Valid": "","valid": "","VALID": "","From": "","from": "","FROM": "", ": ": "", "; ": "" , ". " : "" , "," : ""]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.trimmingCharacters(in: .whitespacesAndNewlines).replaceCommonCharactersWithNumbers().replacingOccurrences(of: "-", with: "")
                
                guard cleanedPotentialMatch.count == 8 else { continue search }
                
                guard let validFrom = cleanedPotentialMatch.stringToDate(withFormat: "yyyyMMdd") else { continue search }
                
                ValidFromParsed = true
                Model.ValidFrom = validFrom
                break search
            }
        }
    }
    
    
    // MARK: Internal Methods
    func Reset() {
        Model = BaseSouthAfricaVisaModel()
        TitleParsed = false
        NamesParsed = false
        PassportNumberParsed = false
        NumberOfEntriesParsed = false
        ValidFromParsed = false
        ReferenceNumberParsed = false
        DateOfExpiryParsed = false
        IssuedAtParsed = false
        ControlNumberParsed = false
    }
}

