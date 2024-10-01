//
//  PhilippinesDriversLicenseParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin.IOS.Common
import MLKitBarcodeScanning
import Foundation

struct PhilippinesDriversLicenseParser {
    
    // MARK: Private Properties
    private var NamesParsed = false
    private var NationalityParsed = false
    private var SexParsed = false
    private var DateOfBirthParsed = false
//    private var WeightParsed = false
//    private var HeightParsed = false
    private var AddressParsed = false
    private var LicenseNumberParsed = false
    private var ExpirationDateParsed = false
    private var AgencyCodeParsed = false
//    private var BloodTypeParsed = false
//    private var EyeColorParsed = false
//    private var RestrictionsParsed = false
//    private var ConditionsParsed = false
    private var SerialNumberParsed = false
    private var Model = PhilippinesDriversLicenseModel()
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: - frames
    var frames = 0
    var maxFrames = 3
    
    var isDLicense = false
    var getCardTrys = 0
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: PhilippinesDriversLicenseModel) -> Void) {
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
//        // Finding Names
//        if !NamesParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return ((itemText.contains("last") || itemText.contains("first") || itemText.contains("middle")) && itemText.contains("name"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Left) else { continue search }
//                
//                let lineBelowText = lineBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard lineBelowText.count >= 2 && lineBelowText.count <= 40 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(lineBelowText) else { continue search }
//                
//                let namesSplit = lineBelowText.split(separator: ",")
//                
//                guard namesSplit.count >= 2 else { continue search }
//                
//                NamesParsed = true
//                Model.LastName = String(namesSplit[0])
//                Model.Names = String(namesSplit[1])
//                break search
//            }
//        }
//        
//        // Finding Nationality
//        if !NationalityParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("nationality"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//                
//                guard elementBelowText.count == 3 else { continue search }
//                
//                guard RegexConstants.NoNumbers.matches(elementBelowText) else { continue search }
//                
//                NationalityParsed = true
//                Model.Nationality = elementBelowText
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
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Center) else { continue search }
//                
//                switch elementBelow.Text.replaceCommonCharactersWithLetters().lowercased() {
//                    case "m":
//                        SexParsed = true
//                        Model.Sex = .Male
//                        break search
//                    case "f":
//                        SexParsed = true
//                        Model.Sex = .Female
//                        break search
//                    default: continue search
//                }
//            }
//        }
//        
//        // Finding Date Of Birth
//        if !DateOfBirthParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("birth"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                guard elementBelowText.count == 8 else { continue search }
//
//                guard let dateOfBirth = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//                
//                guard dateOfBirth.isRealisticBirthDate else { continue search }
//
//                DateOfBirthParsed = true
//                Model.DateOfBirth = dateOfBirth
//                break search
//            }
//        }
//        
//        // Finding Weight
////        if !WeightParsed {
////            let potentialMatches = sybrinItemGroup.Elements.filter { item in
////                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
////                return (itemText.contains("weight"))
////            }
////
////            search: for potentialMatch in potentialMatches {
////                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
////
////                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
////
////                guard let weight = Float(elementBelowText) else { continue search }
////
////                WeightParsed = true
////                Model.Weight = weight
////                break search
////            }
////        }
//        
//        // Finding Height
////        if !HeightParsed {
////            let potentialMatches = sybrinItemGroup.Elements.filter { item in
////                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
////                return (itemText.contains("height"))
////            }
////
////            search: for potentialMatch in potentialMatches {
////                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
////
////                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
////
////                guard let height = Float(elementBelowText), height <= 5 else { continue search }
////
////                HeightParsed = true
////                Model.Height = height
////                break search
////            }
////        }
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
//                    guard !lineBelowText.replaceCommonCharactersWithLetters().lowercased().contains("license") else { break potentialLine }
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
//        // Finding License Number
//        if !LicenseNumberParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("license"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//
//                guard elementBelow.Text.count == 13 else { continue search }
//                
//                let elementBelowText = elementBelow.Text.substring(to: 1).replaceCommonCharactersWithLetters() + elementBelow.Text.suffix(12).replaceCommonCharactersWithNumbers()
//                
//                guard RegexConstants.Philippines_LicenseNumber.matches(elementBelowText) else { continue search }
//
//                LicenseNumberParsed = true
//                Model.LicenseNumber = elementBelowText
//                break search
//            }
//        }
//        
//        // Finding Expiration Date
//        if !ExpirationDateParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("expiration"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                guard elementBelowText.count == 8 else { continue search }
//
//                guard let expirationDate = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//
//                ExpirationDateParsed = true
//                Model.ExpirationDate = expirationDate
//                break search
//            }
//        }
//        
//        // Finding Agency Code
//        if !AgencyCodeParsed {
//            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("agency"))
//            }
//            
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                
//                guard elementBelow.Text.count == 3 else { continue search }
//                
//                let elementBelowText = elementBelow.Text.substring(to: 1).replaceCommonCharactersWithLetters() + elementBelow.Text.suffix(2).replaceCommonCharactersWithNumbers()
//                
//                guard RegexConstants.Philippines_AgencyCode.matches(elementBelowText) else { continue search }
//                
//                AgencyCodeParsed = true
//                Model.AgencyCode = elementBelowText
//                break search
//            }
//        }
//        
//        // Finding Blood Type
////        if !BloodTypeParsed {
////            let potentialMatches = sybrinItemGroup.Lines.filter { item in
////                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
////                return (itemText.contains("blood"))
////            }
////
////            search: for potentialMatch in potentialMatches {
////                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
////
////                let lineBelowText = lineBelow.Text.replaceCommonLettersAndNumbersWithCharacters().replaceCommonCharactersWithLetters()
////
////                let indexOfPlus = lineBelowText.indexOf(str: "+") ?? -1
////                let indexOfMinus = lineBelowText.indexOf(str: "-") ?? -1
////
////                guard indexOfPlus > -1 || indexOfMinus > -1 else { continue search }
////
////                var potentialBloodType = ""
////
////                if indexOfPlus > -1 {
////                    potentialBloodType = lineBelowText.substring(to: indexOfPlus + 1)
////                }
////
////                if indexOfMinus > -1 {
////                    potentialBloodType = lineBelowText.substring(to: indexOfMinus + 1)
////                }
////
////                guard RegexConstants.BloodType.matches(potentialBloodType) else { continue search }
////
////                BloodTypeParsed = true
////                Model.BloodType = potentialBloodType
////                break search
////            }
////        }
//        
//        // Finding Eye Color
////        if !EyeColorParsed {
////            let potentialMatches = sybrinItemGroup.Elements.filter { item in
////                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
////                return (itemText.contains("eye"))
////            }
////
////            search: for potentialMatch in potentialMatches {
////                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
////
////                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
////
////                guard elementBelowText.count >= 2 && elementBelowText.count <= 10 else { continue search }
////
////                EyeColorParsed = true
////                Model.EyeColor = elementBelowText
////                break search
////            }
////        }
//        
//        // Finding Restrictions
////        if !RestrictionsParsed {
////            let potentialMatches = sybrinItemGroup.Elements.filter { item in
////                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
////                return (itemText.contains("restrictions"))
////            }
////
////            search: for potentialMatch in potentialMatches {
////                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
////
////                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: ".", with: ",")
////
////                RestrictionsParsed = true
////                Model.Restrictions = elementBelowText
////                break search
////            }
////        }
//        
//        // Finding Conditions
////        if !ConditionsParsed {
////            let potentialMatches = sybrinItemGroup.Elements.filter { item in
////                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
////                return (itemText.contains("conditions"))
////            }
////
////            search: for potentialMatch in potentialMatches {
////                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
////
////                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
////
////                ConditionsParsed = true
////                Model.Conditions = elementBelowText
////                break search
////            }
////        }
//        
//        if AreRequiredFrontTextFieldsParsed() {
//            success(Model)
//            Reset()
//        }
//        
//    }
//    
//    mutating func ParseBackText(from result: Text, success: @escaping (_ model: PhilippinesDriversLicenseModel) -> Void) {
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
//        // Finding Serial Number
//        if !SerialNumberParsed {
//            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                return (itemText.contains("serial"))
//            }
//
//            search: for potentialMatch in potentialMatches {
//                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search}
//
//                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//
//                guard elementBelowText.count == 9 else { continue search }
//
//                guard RegexConstants.Philippines_SerialNumber.matches(elementBelowText) else { continue search }
//
//                SerialNumberParsed = true
//                Model.SerialNumber = elementBelowText
//                break search
//            }
//        }
//        
//        if SerialNumberParsed {
//            success(Model)
//            Reset()
//        }
//        
////        if AreRequiredBackTextFieldsParsed() {
////            success(Model)
////            Reset()
////        }
//        
//    }
    
    mutating func ParseBackBarcode(from result: Barcode, success: @escaping (_ model: PhilippinesDriversLicenseModel) -> Void) {
        
        // Resetting model if needed
        resetCheck: if ResetEveryMilliseconds >= 0 {
            let currentTimeMs = Date().timeIntervalSince1970 * 1000
            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
            PreviousResetTime = currentTimeMs

            Reset()
        }

        if let barcodeResult = result.displayValue {
            Model.BarcodeData = barcodeResult
            success(Model)
            Reset()
        }
    }
    
    // MARK: - Partial Scans
    
//    mutating func ParseFrontPartialScan(from result: Text, success: @escaping (_ model: PhilippinesDriversLicenseModel) -> Void) {
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
//        if !isDLicense {
//            let _ = sybrinItemGroup.Lines.filter { item in
//                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                
//                if itemText.contains("driver") || itemText.contains("driver's") {
//                    isDLicense = true
//                }
//                
//                return ((itemText.contains("last") || itemText.contains("first") || itemText.contains("middle")) && itemText.contains("name"))
//            }
//        }
//        
//        if isDLicense {
//            // Finding Names
//            if !NamesParsed {
//                let potentialMatches = sybrinItemGroup.Lines.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return ((itemText.contains("last") || itemText.contains("first") || itemText.contains("middle")) && itemText.contains("name"))
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
//                    Model.LastName = String(namesSplit[0])
//                    Model.Names = String(namesSplit[1])
//                    break search
//                }
//            }
//            
//            // Finding Nationality
//            if !NationalityParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("nationality"))
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
//                    NationalityParsed = true
//                    Model.Nationality = elementBelowText
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
//            // Finding Date Of Birth
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
//            // Finding Weight
//    //        if !WeightParsed {
//    //            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//    //                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    //                return (itemText.contains("weight"))
//    //            }
//    //
//    //            search: for potentialMatch in potentialMatches {
//    //                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//    //
//    //                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//    //
//    //                guard let weight = Float(elementBelowText) else { continue search }
//    //
//    //                WeightParsed = true
//    //                Model.Weight = weight
//    //                break search
//    //            }
//    //        }
//            
//            // Finding Height
//    //        if !HeightParsed {
//    //            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//    //                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    //                return (itemText.contains("height"))
//    //            }
//    //
//    //            search: for potentialMatch in potentialMatches {
//    //                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//    //
//    //                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//    //
//    //                guard let height = Float(elementBelowText), height <= 5 else { continue search }
//    //
//    //                HeightParsed = true
//    //                Model.Height = height
//    //                break search
//    //            }
//    //        }
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
//                        guard !lineBelowText.replaceCommonCharactersWithLetters().lowercased().contains("license") else { break potentialLine }
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
//            // Finding License Number
//            if !LicenseNumberParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("license"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//
//                    guard elementBelow.Text.count == 13 else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.substring(to: 1).replaceCommonCharactersWithLetters() + elementBelow.Text.suffix(12).replaceCommonCharactersWithNumbers()
//                    
//                    guard RegexConstants.Philippines_LicenseNumber.matches(elementBelowText) else { continue search }
//
//                    LicenseNumberParsed = true
//                    Model.LicenseNumber = elementBelowText
//                    break search
//                }
//            }
//            
//            // Finding Expiration Date
//            if !ExpirationDateParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("expiration"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: "/", with: "")
//
//                    guard elementBelowText.count == 8 else { continue search }
//
//                    guard let expirationDate = elementBelowText.stringToDate(withFormat: "yyyyMMdd") else { continue search }
//
//                    ExpirationDateParsed = true
//                    Model.ExpirationDate = expirationDate
//                    break search
//                }
//            }
//            
//            // Finding Agency Code
//            if !AgencyCodeParsed {
//                let potentialMatches = sybrinItemGroup.Elements.filter { item in
//                    let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//                    return (itemText.contains("agency"))
//                }
//                
//                search: for potentialMatch in potentialMatches {
//                    guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//                    
//                    guard elementBelow.Text.count == 3 else { continue search }
//                    
//                    let elementBelowText = elementBelow.Text.substring(to: 1).replaceCommonCharactersWithLetters() + elementBelow.Text.suffix(2).replaceCommonCharactersWithNumbers()
//                    
//                    guard RegexConstants.Philippines_AgencyCode.matches(elementBelowText) else { continue search }
//                    
//                    AgencyCodeParsed = true
//                    Model.AgencyCode = elementBelowText
//                    break search
//                }
//            }
//            
//            // Finding Blood Type
//    //        if !BloodTypeParsed {
//    //            let potentialMatches = sybrinItemGroup.Lines.filter { item in
//    //                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    //                return (itemText.contains("blood"))
//    //            }
//    //
//    //            search: for potentialMatch in potentialMatches {
//    //                guard let lineBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Lines, aligned: .Inline) else { continue search }
//    //
//    //                let lineBelowText = lineBelow.Text.replaceCommonLettersAndNumbersWithCharacters().replaceCommonCharactersWithLetters()
//    //
//    //                let indexOfPlus = lineBelowText.indexOf(str: "+") ?? -1
//    //                let indexOfMinus = lineBelowText.indexOf(str: "-") ?? -1
//    //
//    //                guard indexOfPlus > -1 || indexOfMinus > -1 else { continue search }
//    //
//    //                var potentialBloodType = ""
//    //
//    //                if indexOfPlus > -1 {
//    //                    potentialBloodType = lineBelowText.substring(to: indexOfPlus + 1)
//    //                }
//    //
//    //                if indexOfMinus > -1 {
//    //                    potentialBloodType = lineBelowText.substring(to: indexOfMinus + 1)
//    //                }
//    //
//    //                guard RegexConstants.BloodType.matches(potentialBloodType) else { continue search }
//    //
//    //                BloodTypeParsed = true
//    //                Model.BloodType = potentialBloodType
//    //                break search
//    //            }
//    //        }
//            
//            // Finding Eye Color
//    //        if !EyeColorParsed {
//    //            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//    //                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    //                return (itemText.contains("eye"))
//    //            }
//    //
//    //            search: for potentialMatch in potentialMatches {
//    //                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//    //
//    //                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//    //
//    //                guard elementBelowText.count >= 2 && elementBelowText.count <= 10 else { continue search }
//    //
//    //                EyeColorParsed = true
//    //                Model.EyeColor = elementBelowText
//    //                break search
//    //            }
//    //        }
//            
//            // Finding Restrictions
//    //        if !RestrictionsParsed {
//    //            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//    //                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    //                return (itemText.contains("restrictions"))
//    //            }
//    //
//    //            search: for potentialMatch in potentialMatches {
//    //                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//    //
//    //                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers().replacingOccurrences(of: ".", with: ",")
//    //
//    //                RestrictionsParsed = true
//    //                Model.Restrictions = elementBelowText
//    //                break search
//    //            }
//    //        }
//            
//            // Finding Conditions
//    //        if !ConditionsParsed {
//    //            let potentialMatches = sybrinItemGroup.Elements.filter { item in
//    //                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//    //                return (itemText.contains("conditions"))
//    //            }
//    //
//    //            search: for potentialMatch in potentialMatches {
//    //                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search }
//    //
//    //                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithLetters()
//    //
//    //                ConditionsParsed = true
//    //                Model.Conditions = elementBelowText
//    //                break search
//    //            }
//    //        }
//            
//            frames = frames + 1
//        }
//        
//        if AreRequiredFrontTextFieldsParsed() || frames >= maxFrames || getCardTrys >= 6{
//            success(Model)
//            Reset()
//        }
//        
//        getCardTrys = getCardTrys + 1
//        
//    }
//    
////    mutating func ParseBackTextPartialScan(from result: Text, success: @escaping (_ model: PhilippinesDriversLicenseModel) -> Void) {
////        
////        // Resetting model if needed
////        resetCheck: if ResetEveryMilliseconds >= 0 {
////            let currentTimeMs = Date().timeIntervalSince1970 * 1000
////            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
////            PreviousResetTime = currentTimeMs
////
////            Reset()
////        }
////
////        let sybrinItemGroup = MLKitHelper.BlocksToSybrinItemGroup(result.blocks)
////        
//////         Finding Serial Number
////        if !SerialNumberParsed {
////            let potentialMatches = sybrinItemGroup.Lines.filter { item in
////                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
////                return (itemText.contains("serial"))
////            }
////
////            search: for potentialMatch in potentialMatches {
////                guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Inline) else { continue search}
////
////                let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
////
////                guard elementBelowText.count == 9 else { continue search }
////
////                guard RegexConstants.Philippines_SerialNumber.matches(elementBelowText) else { continue search }
////
////                SerialNumberParsed = true
////                Model.SerialNumber = elementBelowText
////                break search
////            }
////        }
////        
////        if SerialNumberParsed {
////            success(Model)
////            Reset()
////        }
////        
//////        if AreRequiredBackTextFieldsParsed() {
//////            success(Model)
//////            Reset()
//////        }
////        
////    }
    
    mutating func ParseBackBarcodePartialScan(from result: Barcode, success: @escaping (_ model: PhilippinesDriversLicenseModel) -> Void) {
        
        // Resetting model if needed
//        resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//
//            Reset()
//        }
//
//        if let barcodeResult = result.displayValue {
//            Model.BarcodeData = barcodeResult
//            success(Model)
//            Reset()
//        }
    }
    
    // MARK: Private Methods
    mutating private func Reset() {
        NamesParsed = false
        NationalityParsed = false
        SexParsed = false
        DateOfBirthParsed = false
//        WeightParsed = false
//        HeightParsed = false
        AddressParsed = false
        LicenseNumberParsed = false
        ExpirationDateParsed = false
        AgencyCodeParsed = false
//        BloodTypeParsed = false
//        EyeColorParsed = false
//        RestrictionsParsed = false
//        ConditionsParsed = false
//        SerialNumberParsed = false
        Model = PhilippinesDriversLicenseModel()
        
        
    }
    
//    private func AreRequiredFrontTextFieldsParsed() -> Bool {
//        return NamesParsed && NationalityParsed && SexParsed && DateOfBirthParsed && WeightParsed && HeightParsed && AddressParsed && LicenseNumberParsed && ExpirationDateParsed && AgencyCodeParsed && EyeColorParsed && RestrictionsParsed && ConditionsParsed
//    }
    
    private func AreRequiredFrontTextFieldsParsed() -> Bool {
        return NamesParsed && NationalityParsed && SexParsed && DateOfBirthParsed && AddressParsed && LicenseNumberParsed && ExpirationDateParsed && AgencyCodeParsed
    }
    
//    private func AreRequiredBackTextFieldsParsed() -> Bool {
//        return SerialNumberParsed
//    }
    
}
