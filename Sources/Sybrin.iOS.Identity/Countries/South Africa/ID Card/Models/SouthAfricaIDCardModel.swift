//
//  SouthAfricaIDCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class SouthAfricaIDCardModel: IDCardModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case surname, names, identityNumberDateOfBirth, identityNumberSex, identityNumberCitizenship, identityNumberADigit, identityNumberCheckDigit, countryOfBirth, citizenship, dateIssued, rsaCode, cardNumber, wordConfidenceResults }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 2.9 }
    final override var CroppingTopOffset: CGFloat { return 0.8 }
    final override var CroppingWidthOffset: CGFloat { return 4.3 }
    final override var CroppingHeightOffset: CGFloat { return 2.7 }
    final override var CroppingBackLeftOffset: CGFloat { return 0.3 }
    final override var CroppingBackTopOffset: CGFloat { return 2.5 }
    final override var CroppingBackWidthOffset: CGFloat { return 1.5 }
    final override var CroppingBackHeightOffset: CGFloat { return 3.7 }
    
    // MARK: Internal Properties
    final var Surname: String?
    final var Names: String?
    final override var IdentityNumber: String? { get { return SouthAfricaIdentityNumber?.IdentityNumber } set { SouthAfricaIdentityNumber = SouthAfricaIdentityNumberParser.ParseIdentityNumber(newValue ?? "") } }
    final var SouthAfricaIdentityNumber: SouthAfricaIdentityNumber?
    final var CountryOfBirth: String?
    final var Citizenship: CitizenshipType?
    final var DateIssued: Date?
    final var RSACode: String?
    final var CardNumber: String?
    
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final override var fullName: String? { get { return "\(self.Names ?? "") \(self.Surname ?? "")" } }
    @objc public final var surname: String? { get { return self.Surname } }
    @objc public final var names: String? { get { return self.Names } }
    @objc public final var identityNumberDateOfBirth: Date? { get { return self.SouthAfricaIdentityNumber?.DateOfBirth } }
    @objc public final var identityNumberSex: Sex { get { return self.SouthAfricaIdentityNumber?.Sex ?? .Undetermined } }
    @objc public final var identityNumberCitizenship: CitizenshipType { get { return self.SouthAfricaIdentityNumber?.Citizenship ?? .Unknown } }
    @objc public final var identityNumberADigit: Int { get { return self.SouthAfricaIdentityNumber?.ADigit ?? -1 } }
    @objc public final var identityNumberCheckDigit: Int { get { return self.SouthAfricaIdentityNumber?.CheckDigit ?? -1 } }
    @objc public final var countryOfBirth: String? { get { return self.CountryOfBirth } }
    @objc public final var citizenship: CitizenshipType { get { return self.Citizenship ?? .Unknown } }
    @objc public final var dateIssued: Date? { get { return self.DateIssued } }
    @objc public final var rsaCode: String? { get { return self.RSACode } }
    @objc public final var cardNumber: String? { get { return self.CardNumber } }
    
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(surname, forKey: .surname)
        try container.encode(names, forKey: .names)
        try container.encode(identityNumberDateOfBirth, forKey: .identityNumberDateOfBirth)
        try container.encode(identityNumberSex, forKey: .identityNumberSex)
        try container.encode(identityNumberCitizenship, forKey: .identityNumberCitizenship)
        try container.encode(identityNumberADigit, forKey: .identityNumberADigit)
        try container.encode(identityNumberCheckDigit, forKey: .identityNumberCheckDigit)
        try container.encode(countryOfBirth, forKey: .countryOfBirth)
        try container.encode(citizenship, forKey: .citizenship)
        try container.encode(dateIssued, forKey: .dateIssued)
        try container.encode(rsaCode, forKey: .rsaCode)
        try container.encode(cardNumber, forKey: .cardNumber)

        try super.encode(to: encoder)
    }
    
}
