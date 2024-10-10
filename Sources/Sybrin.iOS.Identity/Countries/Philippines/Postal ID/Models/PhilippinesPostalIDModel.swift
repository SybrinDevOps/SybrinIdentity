//
//  PhilippinesPostalIDModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesPostalIDModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case fullName, postalReferenceNumber, address, dateOfBirth, validUntil, nationality, issuingPostOffice, cardType, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.4 }
    final override var CroppingTopOffset: CGFloat { return 1.5 }
    final override var CroppingWidthOffset: CGFloat { return 5.5 }
    final override var CroppingHeightOffset: CGFloat { return 3.7 }
    
    // MARK: Internal Properties
    final var FullName: String?
    final var PostalReferenceNumber: String?
    final var Address: String?
    final var DateOfBirth: Date?
    final var ValidUntil: Date?
    final var Nationality: String?
    final var IssuingPostOffice: String?
    final var CardType: String = "Unspecified"
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var fullName: String? { get { return self.FullName } }
    @objc public final var postalReferenceNumber: String? { get { return self.PostalReferenceNumber } }
    @objc public final var address: String? { get { return self.Address } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var validUntil: Date? { get { return self.ValidUntil } }
    @objc public final var nationality: String? { get { return self.Nationality } }
    @objc public final var issuingPostOffice: String? { get { return self.IssuingPostOffice } }
    @objc public final var cardType: String { get { return self.CardType } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fullName, forKey: .fullName)
        try container.encode(postalReferenceNumber, forKey: .postalReferenceNumber)
        try container.encode(address, forKey: .address)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(validUntil, forKey: .validUntil)
        try container.encode(nationality, forKey: .nationality)
        try container.encode(issuingPostOffice, forKey: .issuingPostOffice)
        try container.encode(cardType, forKey: .cardType)

        try super.encode(to: encoder)
    }
    
}
