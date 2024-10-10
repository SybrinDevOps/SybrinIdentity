//
//  SouthAfricaIdentityNumberParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

////import MLKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import MLKitFaceDetection  ////import MLKit
import MLKitBarcodeScanning
import UIKit

struct SouthAfricaIdentityNumberParser {
    
    // MARK: Parse Methods
    static func ParseIdentityNumber(_ potentialIDNumber: String) -> SouthAfricaIdentityNumber? {
        var model = SouthAfricaIdentityNumber()
        
        guard potentialIDNumber.count == 13 else { return nil }
        
        guard RegexConstants.SouthAfrica_IdentityNumber.matches(potentialIDNumber) else { return nil }
        
        model.IdentityNumber = potentialIDNumber
        
        guard let dateOfBirth = ParseIdentityNumberDateOfBirth(potentialIDNumber) else { return nil }
        
        model.DateOfBirth = dateOfBirth
        
        guard let sex = ParseIdentityNumberSex(potentialIDNumber) else { return nil }
        
        model.Sex = sex
        
        guard let citizenship = ParseIdentityNumberCitizenship(potentialIDNumber) else { return nil }
        
        model.Citizenship = citizenship
        
        guard let aDigit = ParseIdentityNumberADigit(potentialIDNumber) else { return nil }
        
        model.ADigit = aDigit
        
        guard let checkDigit = ParseIdentityNumberCheckDigit(potentialIDNumber) else { return nil }
        
        model.CheckDigit = checkDigit
        
        guard ValidateIdentityNumberCheckDigit(potentialIDNumber, checkDigit) else { return nil }
        
        return model
    }
    
    // MARK: Private Methods
    private static func ParseIdentityNumberDateOfBirth(_ potentialIDNumber: String) -> Date? {
        guard let tempDateOfBirth = potentialIDNumber.substring(with: 0..<6).stringToDate(withFormat: "yyMMdd") else { return nil }
        
        return tempDateOfBirth
    }
    
    private static func ParseIdentityNumberSex(_ potentialIDNumber: String) -> Sex? {
        guard let tempSexNumber = Int(potentialIDNumber.substring(with: 6..<10)), tempSexNumber >= 0 && tempSexNumber <= 9999 ,let tempSex = (tempSexNumber >= 5000) ? 0 : 1 else { return nil }
        
        return Sex(rawValue: tempSex)
    }
    
    private static func ParseIdentityNumberCitizenship(_ potentialIDNumber: String) -> CitizenshipType? {
        guard let tempCitizenNumber = Int(potentialIDNumber.substring(with: 10..<11)) else { return nil }
        
        if tempCitizenNumber == 0 {
            return .Citizen
        } else if tempCitizenNumber == 1 {
            return .PermanentResident
        } else {
            return nil
        }
    }
    
    private static func ParseIdentityNumberADigit(_ potentialIDNumber: String) -> Int? {
        guard let tempADigitNumber = Int(potentialIDNumber.substring(with: 11..<12)) else { return nil }
        
        return (tempADigitNumber == 8 || tempADigitNumber == 9) ? tempADigitNumber : nil
    }
    
    private static func ParseIdentityNumberCheckDigit(_ potentialIDNumber: String) -> Int? {
        guard let tempCheckDigitNumber = Int(potentialIDNumber.substring(with: 12..<13)) else { return nil }
        
        return tempCheckDigitNumber
    }
    
    private static func ValidateIdentityNumberCheckDigit(_ potentialIDNumber: String, _ checkDigit: Int) -> Bool {
        return (CheckDigitValidator.GetCheckDigitUsingLuhnAlgorithm(for: potentialIDNumber) == checkDigit)
    }
}
