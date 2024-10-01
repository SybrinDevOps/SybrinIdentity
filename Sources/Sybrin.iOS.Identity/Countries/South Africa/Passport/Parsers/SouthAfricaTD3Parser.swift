//
//  SouthAfricaTD3Parser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import MLKitFaceDetection  ////import MLKit
import MLKitBarcodeScanning
import UIKit

final class SouthAfricaTD3Parser: TraditionalTD3Parser {
    
    final override func ParseLine1(from line: String) {
        guard !Line1Parsed else { "Validation Failed: Line 1 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 44 else { "Validation Failed: Line 1 Length".log(.ProtectedWarning); return }
                
        guard Line1Regex.matches(line) else { "Validation Failed: Line 1 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentType = line.substring(with: 0..<2).replacingOccurrences(of: "<", with: "")
                
        guard let documentType = Model.DocumentType, documentType.count > 0 else { "Parse Failed: Document Type".log(.ProtectedWarning); return }
        
        guard RegexConstants.SouthAfrica_Generic_PassportType.matches(documentType) else { "Validation Failed: Document Type Regex".log(.ProtectedWarning); return }
        
        Model.IssuingCountryCode = line.substring(with: 2..<5)
        
        guard Model.IssuingCountryCode == Country.SouthAfrica.passportCountryCode else { "Validation Failed: Issuing Country Code".log(.ProtectedWarning); return }
        
        let namesArr = line.substring(from: 5).components(separatedBy: "<<")
        
        guard namesArr.count > 1 else { "Parse Failed: Names Split".log(.ProtectedWarning); return }
        
        if (namesArr[0].count > 0) {
            Model.Surname = namesArr[0].replacingOccurrences(of: "<", with: " ")
        }
        
        if (namesArr[1].count > 0) {
            Model.Names = namesArr[1].replacingOccurrences(of: "<", with: " ")
        }
        
        Line1 = line
        Model.MRZLine1 = Line1
        Line1Parsed = true
    }
    
    final override func ParseLine2(from line: String) {
        guard !Line2Parsed else { "Validation Failed: Line 2 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 44 else { "Validation Failed: Line 2 Length".log(.ProtectedWarning); return }
                
        guard Line2Regex.matches(line) else { "Validation Failed: Line 2 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = line.substring(with: 0..<9)
                
        guard let documentNumber = Model.DocumentNumber, let documentType = Model.DocumentType else { "Parse Failed: Document Number".log(.ProtectedWarning); return }
        
        guard ValidatePassportNumber(documentNumber, for: documentType) else { "Validation Failed: Document Number Regex".log(.ProtectedWarning); return }
        
        Model.DocumentNumberCheckDigit = Int(line.substring(with: 9..<10))
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Parse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: documentNumber) == documentNumberCheckDigit else { "Validation Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        Model.NationalityCountryCode = line.substring(with: 10..<13)
        
        Model.DateOfBirth = line.substring(with: 13..<19).stringToDate(withFormat: "yyMMdd")
        
        guard let dateOfBirth = Model.DateOfBirth?.dateToString(withFormat: "yyMMdd") else { "Parse Failed: Date Of Birth".log(.ProtectedWarning); return }
        
        Model.DateOfBirthCheckDigit = Int(line.substring(with: 19..<20))
        
        guard let dateOfBirthCheckDigit = Model.DateOfBirthCheckDigit else { "Parse Failed: Date Of Birth Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: dateOfBirth) == dateOfBirthCheckDigit else { "Validation Failed: Date Of Birth Check Digit".log(.ProtectedWarning); return }
        
        Model.Sex = line.substring(with: 20..<21) == "M" ? Sex(rawValue: 0) : Sex(rawValue: 1)
        
        Model.DateOfExpiry = line.substring(with: 21..<27).stringToDate(withFormat: "yyMMdd")
        
        guard let dateOfExpiry = Model.DateOfExpiry?.dateToString(withFormat: "yyMMdd") else { "Parse Failed: Date Of Expiry".log(.ProtectedWarning); return }
        
        Model.DateOfExpiryCheckDigit = Int(line.substring(with: 27..<28))
        
        guard let dateOfExpiryCheckDigit = Model.DateOfExpiryCheckDigit else { "Parse Failed: Date Of Expiry Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: dateOfExpiry) == dateOfExpiryCheckDigit else { "Validation Failed: Date Of Expiry Check Digit".log(.ProtectedWarning); return }
        
        Model.OptionalData = line.substring(with: 28..<42)
        
        let optionalData = Model.OptionalData ?? ""
        
        Model.OptionalDataCheckDigit = Int(line.substring(with: 42..<43))
        
        guard let optionalDataCheckDigit = Model.OptionalDataCheckDigit else { "Parse Failed: Optional Data Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: optionalData) == optionalDataCheckDigit else { "Validation Failed: Optional Data Check Digit".log(.ProtectedWarning); return }
        
        Model.CompositeCheckDigit = Int(line.substring(with: 43..<44))
        
        guard let compositeCheckDigit = Model.CompositeCheckDigit else { "Parse Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: "\(documentNumber)\(documentNumberCheckDigit)\(dateOfBirth)\(dateOfBirthCheckDigit)\(dateOfExpiry)\(dateOfExpiryCheckDigit)\(optionalData)\(optionalDataCheckDigit)") == compositeCheckDigit else { "Validation Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = Model.DocumentNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Model.OptionalData = Model.OptionalData?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        let identityNumber = Model.OptionalData ?? ""
        
        guard RegexConstants.SouthAfrica_IdentityNumber.matches(identityNumber) else { "Validation Failed: Identity Number Regex".log(.ProtectedWarning); return }
        
        Line2 = line
        Model.MRZLine2 = Line2
        Line2Parsed = true
    }
    
    // MARK: Private Methods
    private func ValidatePassportNumber(_ passportNumber: String, for passportType: String) -> Bool {
        //Validate if the Passport Type is appropriate for the passport number prefix.
        //ref: http://www.e4.co.za/downloads/passport.pdf
        
        switch passportType {
        case "PE": return RegexConstants.SouthAfrica_PE_PassportType.matches(passportNumber)
        case "PT": return RegexConstants.SouthAfrica_PT_PassportType.matches(passportNumber)
        case "PA": return RegexConstants.SouthAfrica_PA_PassportType.matches(passportNumber)
        case "PM": return RegexConstants.SouthAfrica_PM_PassportType.matches(passportNumber)
        case "PD": return RegexConstants.SouthAfrica_PD_PassportType.matches(passportNumber)
        default: return false
        }
    }

}
