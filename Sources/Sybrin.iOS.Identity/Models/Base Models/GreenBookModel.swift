//
//  GreenBookModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Foundation

@objc public class GreenBookModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case identityNumber, surname, firstNames, countryOfBirth, dateOfBirth, dateIssued, bookType }
    
    // MARK: Internal Properties
    var IdentityNumber: String?
    var Surname: String?
    var FirstNames: String?
    var CountryOfBirth: String?
    var DateOfBirth: Date?
    var DateIssued: Date?
    var BookType: GreenBookType = .Unspecified
    
    // MARK: Public Properties
    @objc public var identityNumber: String? { get { return IdentityNumber } }
    @objc public var surname: String? { get { return Surname } }
    @objc public var firstNames: String? { get { return FirstNames } }
    @objc public var countryOfBirth: String? { get { return CountryOfBirth } }
    @objc public var dateOfBirth: Date? { get { return DateOfBirth } }
    @objc public var dateIssued: Date? { get { return DateIssued } }
    @objc public var bookType: GreenBookType { get { return BookType } }
    
    // MARK: Public Methods
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identityNumber, forKey: .identityNumber)
        try container.encode(surname, forKey: .surname)
        try container.encode(firstNames, forKey: .firstNames)
        try container.encode(countryOfBirth, forKey: .countryOfBirth)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(dateIssued, forKey: .dateIssued)
        try container.encode(bookType, forKey: .bookType)
        
        try super.encode(to: encoder)
    }
    
}
