//
//  TraditionalMRVAParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/13.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Foundation

class TraditionalMRVAParser {
    
    // MARK: Internal Properties
    var Line1: String?
    var Line2: String?
    var Line1Regex: NSRegularExpression { get { return RegexConstants.MRVA_MRZ_Line1 } }
    var Line2Regex: NSRegularExpression { get { return RegexConstants.MRVA_MRZ_Line2 } }
    var Model: MRVAModel = MRVAModel()
    var Line1Parsed: Bool = false
    var Line2Parsed: Bool = false
    
    // MARK: Parse Methods
    func ParseLine1(from line: String) {
        guard !Line1Parsed else { "Validation Failed: Line 1 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 44 else { "Validation Failed: Line 1 Length".log(.ProtectedWarning); return }
        
        guard Line1Regex.matches(line) else { "Validation Failed: Line 1 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentType = line.substring(with: 0..<2).replacingOccurrences(of: "<", with: "")
        
        guard Model.DocumentType?.count ?? 0 > 0 else { "Parse Failed: Document Type".log(.ProtectedWarning); return }
        
        Model.IssuingCountryCode = line.substring(with: 2..<5)
        
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
    
    func ParseLine2(from line: String) {
        guard !Line2Parsed else { "Validation Failed: Line 2 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 44 else { "Validation Failed: Line 2 Length".log(.ProtectedWarning); return }
        
        guard Line2Regex.matches(line) else { "Validation Failed: Line 2 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = line.substring(with: 0..<9)
        
        guard let documentNumber = Model.DocumentNumber else { "Parse Failed: Document Number".log(.ProtectedWarning); return }
        
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
        
        Model.OptionalData = line.substring(with: 28..<44).trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Model.DocumentNumber = Model.DocumentNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Line2 = line
        Model.MRZLine2 = Line2
        Line2Parsed = true
    }
    
    // MARK: Internal Methods
    func Reset() {
        Line1 = nil
        Line2 = nil
        Model = MRVAModel()
        Line1Parsed = false
        Line2Parsed = false
    }
    
}
