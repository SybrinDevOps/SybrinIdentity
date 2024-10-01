////
////  PhilippinesIdentificationCardParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Default on 2022/05/04.
////  Copyright © 2022 Sybrin Systems. All rights reserved.
////
//
////import MLKit
//
//struct PhilippinesIdentificationCardParser {
//    
//    // MARK: Private Properties
//    
//    private var AddressParsed = false
//    private var NamesParsed = false
//    private var DateOfIssuedParsed = false
//    private var DateOfBirthParsed = false
//    private var SexParsed = false
//    private var maritalStatusParsed = false
//    private var placeOfBirthParsed = false
//    private var commonReferenceNumberParsed = false
//    private var bloodTypeParsed = false
//    
//    private var Model = PhilippinesIdentificationCardModel()
//    
//    // Resetting Model
//    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private let ResetEveryMilliseconds: Double = 10000
//    
//    // MARK: - frames
//    var frames = 0
//    var maxFrames = 3
//    
//    var isIDCard = false
//    var getCardTrys = 0
//    
//    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
//        
//    }
//    
//    mutating func ParseBackText(from result: Text, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
//
//        
//    }
//    
//    mutating func ParseBackBarcode(from result: Barcode, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
//
//
//    }
//    
//    
//    
//    // MARK: - Partial Scans
//    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
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
//        if !isIDCard {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if itemText.contains("philipine") || itemText.contains("identification") || itemText.contains("card") {
//                    isIDCard = true
//                }
//                
//                return ((itemText.contains("last") || itemText.contains("first") || itemText.contains("middle")) && itemText.contains("name"))
//            }
//        }
//        
//        
//        
//        if !isIDCard {
//            
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
//                        guard !lineBelowText.replaceCommonCharactersWithLetters().lowercased().contains("address") else { break potentialLine }
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
//                }            }
//            
//            if !NamesParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return ((itemText.contains("given") || itemText.contains("last") && itemText.contains("name") ||  itemText.contains("names")))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                    
//                    let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                    
//                    let namesSplit = lineBelowText.split(separator: ",")
//                    
//                    guard namesSplit.count >= 2 else { continue search }
//                    
//                    NamesParsed = true
//                    Model.GivenNames = String(namesSplit[0])
//                    Model.LastName = String(namesSplit[1])
//                    Model.MiddleName = String(namesSplit[3])
//
//                    break search
//                }
//
//            }
//            
//            if !DateOfIssuedParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("issue") || itemText.contains("issued"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                    guard elementBelowText.count == 8 else { continue search }
//
//                    guard let dateOfBirth = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                    
//                    guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                    DateOfIssuedParsed = true
//                    Model.DateOfIssued = dateOfBirth
//                    break search
//                }
//            }
//            
//            if !DateOfBirthParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("birth"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                    guard elementBelowText.count == 8 else { continue search }
//
//                    guard let dateOfBirth = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                    
//                    guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                    DateOfBirthParsed = true
//                    Model.DateOfBirth = dateOfBirth
//                    break search
//                }
//            }
//            
//            if !SexParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("sex"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Center) else { continue search }
//                    
//                    switch elementBelow.Text.replaceCommonCharactersWithLetters().lowercased() {
//                        case "m":
//                            SexParsed = true
//                            Model.Sex = .Male
//                            break search
//                        case "f":
//                            SexParsed = true
//                            Model.Sex = .Female
//                            break search
//                        default: continue search
//                    }
//                }
//            }
//            
//            if !maritalStatusParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("marital status"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard elementBelowText.count == 3 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(elementBelowText) else { continue search }
//                    
//                    maritalStatusParsed = true
//                    Model.MaritalStatus = elementBelowText
//                    break search
//                }
//
//            }
//            
//            if !placeOfBirthParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("place of birth"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard elementBelowText.count == 3 else { continue search }
//                    
//                    guard RegexConstants.NoNumbers.matches(elementBelowText) else { continue search }
//                    
//                    placeOfBirthParsed = true
//                    Model.PlaceOfBirth = elementBelowText
//                    break search
//                }
//            }
//            
//            if !commonReferenceNumberParsed {
//                
//            }
//            
//            if !bloodTypeParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("blood type"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                    
//                    guard elementBelowText.count == 3 else { continue search }
//                    
//                    //guard RegexConstants.NoNumbers.matches(elementBelowText) else { continue search }
//                    
//                    placeOfBirthParsed = true
//                    Model.PlaceOfBirth = elementBelowText
//                    break search
//                }
//
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
//    
//    mutating func ParseBackTextPartialScan(from result: Text, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
//        
////        success(Model)
//        // Resetting model if needed
//        resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//            Reset()
//        }
//        
//        frames = frames + 1
//        
//        if AreRequiredFrontTextFieldsParsed() || frames >= maxFrames || getCardTrys >= 6 {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 7) { [self] in
//                success(Model)
//            }
//            
//        }
//        
//        getCardTrys = getCardTrys + 1
//
//        //if let barcodeResult = result.displayValue {
//            //Model.BarcodeData = barcodeResult
////            success(Model)
////            Reset()
//        //}
//    }
//    
//    mutating func ParseBackBarcodePartialScan(from result: Barcode, success: @escaping (_ model: PhilippinesIdentificationCardModel) -> Void) {
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
//        if let barcodeResult = result.displayValue {
//            //Model.BarcodeData = barcodeResult
//            success(Model)
//            Reset()
//        }
//    }
//    
//    // MARK: Private Methods
//    mutating private func Reset() {
//        AddressParsed = false
//        NamesParsed = false
//        DateOfIssuedParsed = false
//        DateOfBirthParsed = false
//        SexParsed = false
//        maritalStatusParsed = false
//        placeOfBirthParsed = false
//        commonReferenceNumberParsed = false
//        bloodTypeParsed = false
//        Model = PhilippinesIdentificationCardModel()
//    }
//    
//    private func AreRequiredFrontTextFieldsParsed() -> Bool {
//        return AddressParsed &&
//        NamesParsed &&
//        DateOfIssuedParsed &&
//        DateOfBirthParsed &&
//        SexParsed &&
//        maritalStatusParsed &&
//        placeOfBirthParsed &&
//        commonReferenceNumberParsed &&
//        bloodTypeParsed
//    }
//}
