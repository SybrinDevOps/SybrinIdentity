//
//  RegexConstants.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Foundation

struct RegexConstants {
    
    // MARK: Common
    static let AlphaNumeric = NSRegularExpression("[a-zA-Z0-9]")
    static let MRZAccepted = NSRegularExpression("[^a-zA-Z0-9<]")
    static let LettersAndNumbersOnly = NSRegularExpression("^[A-Z0-9]*$")
    static let NoLettersOrNumbers = NSRegularExpression("^[^A-Z0-9]*$")
    static let LettersOnly = NSRegularExpression("^[A-Z]*$")
    static let NoLetters = NSRegularExpression("^[^A-Z]*$")
    static let NumbersOnly = NSRegularExpression("^[0-9]*$")
    static let NoNumbers = NSRegularExpression("^[^0-9]*$")
    static let BloodType = NSRegularExpression("^(A|B|AB|O)[+-]$")
    
    // MARK: Kenya
    static let Kenya_IdentityNumber = NSRegularExpression("^([0-9]{8})$")
    static let Kenya_TD1_MRZ_Line2 = NSRegularExpression("([0-9]{6})([0-9]{1})([M|F|X|<]{1})([0-9]{6})([0-9]{1})([A-Z0-9<]{14})([0-9]{1})$")
    
    // MARK: Mozambique
    static let Mozambique_TD1_MRZ_Line1 = NSRegularExpression("([BI])([A-Z]{3})([A-Z0-9<]{9})([0-9]{1})([A-Z0-9<]{15})$")
    static let Mozambique_IdentityNumber = NSRegularExpression("^([0-9]{12})([A-Z]{1})$")

    // MARK: Philippines
    static let Philippines_PhilHealthNumber = NSRegularExpression("^([0-9]{2}[-][0-9]{9}[-][0-9]{1})$")
    static let Philippines_SocialSecurityNumber = NSRegularExpression("^([0-9]{2}[-][0-9]{7}[-][0-9]{1})$")
    static let Philippines_CommonReferenceNumber = NSRegularExpression("^(([0-9]{12}))$")
    static let Philippines_LicenseNumber = NSRegularExpression("^([A-Z]{1}[0-9]{2}[-][0-9]{2}[-][0-9]{6})$")
    static let Philippines_AgencyCode = NSRegularExpression("^([A-Z]{1}[0-9]{2})$")
    static let Philippines_SerialNumber = NSRegularExpression("^([0-9]{9})$")
    static let Philippines_Seaferer_Record_Book_Document_Number = NSRegularExpression("([a-zA-Z]{1}[0-9]{7})")

    // MARK: South Africa
    static let SouthAfrica_IdentityNumber = NSRegularExpression("(((\\d{2}((0[13578]|1[02])(0[1-9]|[12]\\d|3[01])|(0[13456789]|1[012])(0[1-9]|[12]\\d|30)|02(0[1-9]|1\\d|2[0-8])))|([02468][048]|[13579][26])0229))(( |-)(\\d{4})( |-)(\\d{3})|(\\d{7}))$")
    // South Africa Passport Number Regexs for Passport Type
    static let SouthAfrica_Generic_PassportType = NSRegularExpression("(P[ADMET]{1})$")
    static let SouthAfrica_PE_PassportType = NSRegularExpression("([A]{1})([0-9]{8})$")
    static let SouthAfrica_PT_PassportType = NSRegularExpression("([T]{1})([0-9]{8})$")
    static let SouthAfrica_PA_PassportType = NSRegularExpression("([A]{1})([0-9]{8})$")
    static let SouthAfrica_PM_PassportType = NSRegularExpression("([M]{1})([0-9]{8})$")
    static let SouthAfrica_PD_PassportType = NSRegularExpression("([D]{1})([0-9]{8})$")
    static let SouthAfrica_Visa_Reference_Number = NSRegularExpression("([A-Z]{3} *([0-9]{6}|[0-9]{5}|[0-9]{3})/[0-9]{4}/[A-Z]+)")
    
    // MARK: Uganda
    static let Uganda_IdentityNumber = NSRegularExpression("([A-Z]{2})([0-9]{7})([A-Z0-9]{5})$")
    static let Uganda_TD1_MRZ_Line1 = NSRegularExpression("([ID])([A-Z]{3})([0-9]{9})([0-9]{1})([A-Z]{2})([0-9]{7})([A-Z0-9]{5})([<])$")
    static let Uganda_TD1_MRZ_Line2 = NSRegularExpression("([0-9]{6})([0-9]{1})([M|F|X|<]{1})([0-9]{6})([0-9]{1})([A-Z]{3})([0-9]{6})([A-Z0-9<]{5})([0-9]{1})$")
    
    // MARK: Traditional MRZ Parsers
    // Traditional MRZ Parsers Regex - ref https://www.doubango.org/SDKs/mrz/docs/MRZ_parser.html
    static let TD1_MRZ_Line1 = NSRegularExpression("([A|C|I][A-Z0-9<«]{1})([A-Z]{3})([A-Z0-9<«]{9})([0-9]{1})([A-Z0-9<«]{15})$")
    static let TD1_MRZ_Line2 = NSRegularExpression("([0-9]{6})([0-9]{1})([M|F|X|<]{1})([0-9]{6})([0-9]{1})([A-Z]{3})([A-Z0-9<«]{11})([0-9]{1})$")
    static let TD1_MRZ_Line3 = NSRegularExpression("([A-Z0-9<«]{30})$")
    
    static let TD2_MRZ_Line1 = NSRegularExpression("([A|C|I][A-Z0-9<]{1})([A-Z]{3})([A-Z0-9<]{31})$")
    static let TD2_MRZ_Line2 = NSRegularExpression("([A-Z0-9<]{9})([0-9]{1})([A-Z]{3})([0-9]{6})([0-9]{1})([M|F|X|<]{1})([0-9]{6})([0-9]{1})([A-Z0-9<]{7})([0-9]{1})$")
    
    static let TD3_MRZ_Line1 = NSRegularExpression("(P[A-Z0-9<]{1})([A-Z]{3})([A-Z0-9<]{39})$")
    static let TD3_MRZ_Line2 = NSRegularExpression("([A-Z0-9<]{9})([0-9]{1})([A-Z]{3})([0-9]{6})([0-9]{1})([M|F|X|<]{1})([0-9]{6})([0-9]{1})([A-Z0-9<]{14})([0-9<]{1})([0-9]{1})$")
    
    static let MRVA_MRZ_Line1 = NSRegularExpression("(V[A-Z0-9<]{1})([A-Z]{3})([A-Z0-9<]{39})$")
    static let MRVA_MRZ_Line2 = NSRegularExpression("([A-Z0-9<]{9})([0-9]{1})([A-Z]{3})([0-9]{6})([0-9]{1})([M|F|X|<]{1})([0-9]{6})([0-9]{1})([A-Z0-9<]{16})$")
    
    static let MRVB_MRZ_Line1 = NSRegularExpression("(V[A-Z0-9<]{1})([A-Z]{3})([A-Z0-9<]{31})$")
    static let MRVB_MRZ_Line2 = NSRegularExpression("([A-Z0-9<]{9})([0-9]{1})([A-Z]{3})([0-9]{6})([0-9]{1})([M|F|X|<]{1})([0-9]{6})([0-9]{1})([A-Z0-9<]{8})$")
    
}

extension NSRegularExpression {
    
    public convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    public func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)

        return firstMatch(in: string, options: [], range: range) != nil
    }
    
}
