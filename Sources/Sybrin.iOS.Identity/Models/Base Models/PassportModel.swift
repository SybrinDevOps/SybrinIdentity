//
//  PassportModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Foundation

@objc public class PassportModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case passportType, issuingCountryCode, surname, names, passportNumber, nationality, dateOfBirth, sex, dateOfExpiry }
    
    // MARK: Internal Properties
    var PassportType: String?
    var IssuingCountryCode: String?
    var Surname: String?
    var Names: String?
    var PassportNumber: String?
    var Nationality: String?
    var DateOfBirth: Date?
    var Sex: Sex?
    var DateOfExpiry: Date?
    
    // MARK: Public Properties
    @objc public var passportType: String? { get { return PassportType } }
    @objc public var issuingCountryCode: String? { get { return IssuingCountryCode } }
    @objc public var surname: String? { get { return Surname } }
    @objc public var names: String? { get { return Names } }
    @objc public var passportNumber: String? { get { return PassportNumber } }
    @objc public var nationality: String? { get { return Nationality } }
    @objc public var dateOfBirth: Date? { get { return DateOfBirth } }
    @objc public var sex: Sex { get { return Sex ?? .Undetermined } }
    @objc public var dateOfExpiry: Date? { get { return DateOfExpiry } }
    
    // MARK: Public Methods
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(passportType, forKey: .passportType)
        try container.encode(issuingCountryCode, forKey: .issuingCountryCode)
        try container.encode(surname, forKey: .surname)
        try container.encode(names, forKey: .names)
        try container.encode(passportNumber, forKey: .passportNumber)
        try container.encode(nationality, forKey: .nationality)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(sex, forKey: .sex)
        try container.encode(dateOfExpiry, forKey: .dateOfExpiry)
        
        try super.encode(to: encoder)
    }
    
}
