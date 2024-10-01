//
//  PhilippinesSeafarerIdentificationDocumentParser.swift
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

struct PhilippinesIdentificationCardParser {
    
    // MARK: Private Properties
    
    private var AddressParsed = false
    private var NamesParsed = false
    private var DateOfIssuedParsed = false
    private var DateOfBirthParsed = false
    private var SexParsed = false
    private var maritalStatusParsed = false
    private var placeOfBirthParsed = false
    private var commonReferenceNumberParsed = false
    private var bloodTypeParsed = false
    private var IsFinished = false
    private var LastNameParsed = false
    
    // Parser
    private let Parser = TraditionalTD1Parser()
    
    private var Model = PhilippinesIdentificationCardModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 8
    
    var isIDCard = false
    var isIDCardBack = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
//        let model = PhilippinesIdentificationCardModel()
//        
//        outer: for block in result.blocks {
//        inner: for line in block.lines {
//            let lineText = line.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").lowercased()
//            
//            if lineText.count != 13 {
//                continue inner
//            }
//            
//            let lineTextFixed = lineText.substring(to: 4).replaceCommonCharactersWithLetters() + lineText.substring(from: 4).replaceCommonCharactersWithNumbers()
//            
//            if !lineTextFixed.contains("idno") {
//                continue inner
//            }
//            
//            model.IdentityNumber = lineTextFixed.substring(from: 4)
//        success(model)
//        break outer
//            }
//        }
//    }
//    
//    mutating func ParseBack(from result: Text, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
//    outer: for block in result.blocks {
//    inner: for line in block.lines {
//        
//        // Resetting model if needed
//    resetCheck: if ResetEveryMilliseconds >= 0 {
//        let currentTimeMs = Date().timeIntervalSince1970 * 1000
//        guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//        PreviousResetTime = currentTimeMs
//        
//        Reset()
//    }
//        
//        let lineText = line.text.replacingOccurrences(of: " ", with: "").fixMRZGarbage(completeLength: 30)
//        
//        if (lineText.count == 30 && Parser.Line1Regex.matches(lineText) && !Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed) {
//            Parser.ParseLine1(from: lineText)
//        } else if (lineText.count == 30 && Parser.Line2Regex.matches(lineText) && Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1) {
//            Parser.ParseLine2(from: lineText)
//        } else if (lineText.count == 30 && Parser.Line3Regex.matches(lineText) && Parser.Line1Parsed && Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1 && lineText != Parser.Line2) {
//            Parser.ParseLine3(from: lineText)
//            break outer
//        }
//    }
//    }
//        
//        
//    }
//    
//    // MARK:- Partial Scans
//    
//    mutating
//    func ParseFrontPartialScan(from result: Text,from face: Face?, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
//        let model = PhilippinesIdentificationCardModel()
//        
//        
//        let sybrinItemGroup = MLKitHelper.BlocksToSybrinItemGroup(result.blocks)
//        
//        
//        
//        isIDCard = false
//        if !isIDCard {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if itemText.contains("phillipines") || itemText.contains("identification") ||
//                    itemText.contains("card") ||
//                    itemText.contains("phl") ||
//                    itemText.contains("republika") {
//                    isIDCard = true
//                }
//                
//                return ((itemText.contains("last") || itemText.contains("first") || itemText.contains("middle")) && itemText.contains("name"))
//            }
//        }
//        
//        if !NamesParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    
//                
//                return itemText.contains("given") || itemText.contains("names") || itemText.contains("mga") || itemText.contains("pangalan")
//            }
//                        
//            search: for potentialMatch in potentialMatches {
//                
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                let lineBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                let namesSplit = lineBelowText.split(separator: ",")
//                
//                guard namesSplit.count >= 1 else { continue search }
//                NamesParsed = true
//                //model.GivenNames = String(namesSplit[0])
//                
//                var names = ""
//                for name in namesSplit {
//                    names = names + " " + name
//                }
//                model.GivenNames = lineBelowText //names
//                break search
//            }
//        }
//        
//        if !LastNameParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    
//                
//                return itemText.contains("last") || itemText.contains("apelyido")
//            }
//                        
//            search: for potentialMatch in potentialMatches {
//                
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                let lineBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                model.LastName = lineBelowText
//                
//                break search
//            }
//        }
//        
//        if !AddressParsed {
//            var address = ""
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    
//                
//                return itemText.contains("address") || itemText.contains("tirahan")
//            }
//                        
//            search: for potentialMatch in potentialMatches {
//                var comparingLine: ProtocolSybrinItem = potentialMatch
//                potentialLine: while let lineBelow = MLKitHelper.GetClosestItemBelow(from: comparingLine, items: sybrinItemGroup.Lines, aligned: .Left) {
//                
//                let lineBelowText = lineBelow.Text
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
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
//                model.Address = address
//                break search
//            }
//                
//                break search
//            }
//        }
//        
//        if !DateOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonLettersAndNumbersWithCharacters().lowercased()
//                return (itemText.contains("birth") || itemText.contains("kapanganakan") || itemText.contains("date"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//                
//                guard lineBelow.Text.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: ",", with: "").count >= 11 else { continue search }
//                
//                let dateArray = lineBelow.Text.replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: ",", with: "").split(separator: "-")
//                
//                break search
//            }
//        }
//        
//        if let names = model.GivenNames, let lastName = model.LastName {
//            model.FullName = names + " " + lastName
//        }
//        
//        if(isIDCard && frames >= maxFrames){
//            success(model)
//            ResetFrames()
//        }
//        frames += 1
//    }
//    
//    mutating func ParseBackPartialScan(from result: Text, from face: Face?, success: @escaping (_ finished: Bool, _ model: PhilippinesIdentificationCardModel) -> Void) {
//        
//            let model = PhilippinesIdentificationCardModel()
//            outer: for block in result.blocks {
//                inner: for _ in block.lines {
//            
//            // Resetting model if needed
//            resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//            
//            Reset()
//            }
//        }
//    }
//        
//        let sybrinItemGroup = MLKitHelper.BlocksToSybrinItemGroup(result.blocks)
//        isIDCardBack = false
//        if !isIDCardBack {
//            
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if itemText.contains("sex") || itemText.contains("marital") ||
//                    itemText.contains("blood") {
//                    isIDCardBack = true
//                }
//                
//                return ((itemText.contains("sex") || itemText.contains("marital") || itemText.contains("blood")) && itemText.contains("name"))
//            }
//        }
//        
//        if !DateOfIssuedParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased()
//                return (itemText.contains("issued"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                
//                let elementBelowText = elementBelow.Text.replacingOccurrences(of: "/", with: "")
//
//                guard elementBelowText.count == 8 else { continue search }
//
//                guard let dateOfBirth = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                
//                guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                DateOfIssuedParsed = true
//                model.DateOfIssued = dateOfBirth
//                break search
//            }
//        }
//        
//        if !maritalStatusParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    
//                
//                return itemText.contains("marital") || itemText.contains("status")
//            }
//                        
//            search: for potentialMatch in potentialMatches {
//                
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                let lineBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                model.MaritalStatus = lineBelowText
//                maritalStatusParsed = true
//                
//                break search
//            }
//        }
//        
//        
//        if !bloodTypeParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    
//                
//                return itemText.contains("blood") || itemText.contains("type")
//            }
//                        
//            search: for potentialMatch in potentialMatches {
//                
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                let lineBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                model.MaritalStatus = lineBelowText
//                bloodTypeParsed = true
//                
//                break search
//            }
//        }
//
//
//        
//        if face == nil && isIDCardBack/*, let model = TD1ModelToPhilippinesIdentificationDocumentModel(Parser.Model)*/{
//            if result.blocks.count > 1 && frames >= maxFrames {
//                IsFinished = true
//                success(IsFinished,model)
//                Reset()
//                ResetFrames()
//            }
//            frames = frames + 1
//        }
//    }
    
    func ParseBackBarcode(from result: Barcode, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
        
        if let barcodeResult = result.rawValue {
            
            if let model = ParseBarcodeRes(barcodeResult) {
                success(model)
            }
        }
    }
    
    // MARK: Private Methods
    private mutating func Reset() {
        //Parser.Reset()
        Model = PhilippinesIdentificationCardModel()
        
    }
    
    private func ParseBarcodeRes(_ barcodeResult: String) -> PhilippinesIdentificationCardModel? {
        
        let model = PhilippinesIdentificationCardModel()
        
        
        do {
            let data = try JSONDecoder().decode(IDPhil.self, from: Data(barcodeResult.utf8)) as? IDPhil
            if let fname = data?.subject?.fName, let lname = data?.subject?.lName {
                model.FullName = fname + " " + lname
                model.LastName = lname
            }
            
            model.PlaceOfBirth = data?.subject?.POB
            model.IdentityNumber = data?.subject?.PCN
            switch data?.subject?.sex?.lowercased() {
            case "male":
                model.Sex = .Male
            case "female":
                model.Sex = .Female
            default:
                model.Sex = .Male
            }
            
            return model
            
        } catch {
            
        }
        
        return model
    }
    
    
    private mutating func ResetFrames(){
        frames = 0
        getCardTrys = 0
    }
    
    func getMonth(_ month: String) -> String {
        
        var mmm = "jan"
        switch month.lowercased() {
        case "january":
            mmm = "jan"
        case "february":
            mmm = "feb"
        case "march":
            mmm = "mar"
        case "april":
            mmm = "apr"
        case "may":
            mmm = "may"
        case "june":
            mmm = "jun"
        case "july":
            mmm = "jul"
        case "august":
            mmm = "aug"
        case "september":
            mmm = "sep"
        case "october":
            mmm = "oct"
        case "november":
            mmm = "nov"
        case "december":
            mmm = "dec"
        default:
            mmm = "jan"
            
        }
        
        return mmm
    }
    
}


struct IDPhil : Codable{
    let DateIssued: String?
    let Issuer: String?
    let subject: Subject?
}

struct Subject: Codable {
    let fName: String?
    let lName: String?
    let mName: String?
    let sex: String?
    let BF: String?
    let DOB: String?
    let POB: String?
    let PCN: String
}
