//
//  TraditionalTD1Parser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Foundation

class TraditionalTD1Parser {
    
    // MARK: Internal Properties
    var Line1: String?
    var Line2: String?
    var Line3: String?
    var Line1Regex: NSRegularExpression { get { return RegexConstants.TD1_MRZ_Line1 } }
    var Line2Regex: NSRegularExpression { get { return RegexConstants.TD1_MRZ_Line2 } }
    var Line3Regex: NSRegularExpression { get { return RegexConstants.TD1_MRZ_Line3 } }
    var Model: TD1Model = TD1Model()
    var Line1Parsed: Bool = false
    var Line2Parsed: Bool = false
    var Line3Parsed: Bool = false
    
    // MARK: Parse Methods
    func ParseLine1(from line: String) {
        guard !Line1Parsed else { "Validation Failed: Line 1 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 30 else { "Validation Failed: Line 1 Length".log(.ProtectedWarning); return }
        
        guard Line1Regex.matches(line) else { "Validation Failed: Line 1 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentType = line.substring(with: 0..<2).replacingOccurrences(of: "<", with: "")
        
        guard Model.DocumentType?.count ?? 0 > 0 else { "Parse Failed: Document Type".log(.ProtectedWarning); return }
        
        Model.IssuingCountryCode = line.substring(with: 2..<5)
        
        Model.DocumentNumber = line.substring(with: 5..<14)
        
        guard let documentNumber = Model.DocumentNumber else { "Parse Failed: Document Number".log(.ProtectedWarning); return }
        
        Model.DocumentNumberCheckDigit = Int(line.substring(with: 14..<15))
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Parse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: documentNumber) == documentNumberCheckDigit else { "Validation Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        Model.OptionalData1 = line.substring(with: 15..<30)
        
        Line1 = line
        Model.MRZLine1 = Line1
        Line1Parsed = true
    }
    
    func ParseLine2(from line: String) {
        guard !Line2Parsed else { "Validation Failed: Line 2 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 30 else { "Validation Failed: Line 2 Length".log(.ProtectedWarning); return }
        
        guard Line2Regex.matches(line) else { "Validation Failed: Line 2 Regex".log(.ProtectedWarning); return }
        
        Model.DateOfBirth = line.substring(with: 0..<6).stringToDate(withFormat: "yyMMdd")
        
        guard let dateOfBirth = Model.DateOfBirth?.dateToString(withFormat: "yyMMdd") else { "Parse Failed: Date Of Birth".log(.ProtectedWarning); return }
        
        Model.DateOfBirthCheckDigit = Int(line.substring(with: 6..<7))
        
        guard let dateOfBirthCheckDigit = Model.DateOfBirthCheckDigit else { "Parse Failed: Date Of Birth Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: dateOfBirth) == dateOfBirthCheckDigit else { "Validation Failed: Date Of Birth Check Digit".log(.ProtectedWarning); return }
        
        Model.Sex = line.substring(with: 7..<8) == "M" ? Sex(rawValue: 0) : Sex(rawValue: 1)
        
        Model.DateOfExpiry = line.substring(with: 8..<14).stringToDate(withFormat: "yyMMdd")
        
        guard let dateOfExpiry = Model.DateOfExpiry?.dateToString(withFormat: "yyMMdd") else { "Parse Failed: Date Of Expiry".log(.ProtectedWarning); return }
        
        Model.DateOfExpiryCheckDigit = Int(line.substring(with: 14..<15))
        
        guard let dateOfExpiryCheckDigit = Model.DateOfExpiryCheckDigit else { "Parse Failed: Date Of Expiry Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: dateOfExpiry) == dateOfExpiryCheckDigit else { "Validation Failed: Date Of Expiry Check Digit".log(.ProtectedWarning); return }
        
        Model.NationalityCountryCode = line.substring(with: 15..<18)
        
        Model.OptionalData2 = line.substring(with: 18..<29)
        
        Model.CompositeCheckDigit = Int(line.substring(with: 29..<30))
        
        guard let compositeCheckDigit = Model.CompositeCheckDigit else { "Parse Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        guard let documentNumber = Model.DocumentNumber else { "Reparse Failed: Document Number".log(.ProtectedWarning); return }
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Reparse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        let optionalData1 = Model.OptionalData1 ?? ""
        
        let optionalData2 = Model.OptionalData2 ?? ""
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: "\(documentNumber)\(documentNumberCheckDigit)\(optionalData1)\(dateOfBirth)\(dateOfBirthCheckDigit)\(dateOfExpiry)\(dateOfExpiryCheckDigit)\(optionalData2)") == compositeCheckDigit else { "Validation Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = Model.DocumentNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Model.OptionalData1 = Model.OptionalData1?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Model.OptionalData2 = Model.OptionalData2?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Line2 = line
        Model.MRZLine2 = Line2
        Line2Parsed = true
    }
    
    func ParseLine3(from line: String) {
        guard !Line3Parsed else { "Validation Failed: Line 3 Already Parsed".log(.ProtectedWarning); return }
                
        guard line.count == 30 else { "Validation Failed: Line 3 Length".log(.ProtectedWarning); return }
        
        guard Line3Regex.matches(line) else { "Validation Failed: Line 3 Regex".log(.ProtectedWarning); return }
        
        let namesArr = line.substring(from: 0).components(separatedBy: "<<")
        
        guard namesArr.count > 1 else { "Parse Failed: Names Split".log(.ProtectedWarning); return }
        
        if (namesArr[0].count > 0) {
            Model.Surname = namesArr[0].replacingOccurrences(of: "<", with: " ")
        }
        
        if (namesArr[1].count > 0) {
            Model.Names = namesArr[1].replacingOccurrences(of: "<", with: " ")
        }
        
        Line3 = line
        Model.MRZLine3 = Line3
        Line3Parsed = true
    }
    
    // MARK: Internal Methods
    func Reset() {
        Line1 = nil
        Line2 = nil
        Line3 = nil
        Model = TD1Model()
        Line1Parsed = false
        Line2Parsed = false
        Line3Parsed = false
    }
    
}
