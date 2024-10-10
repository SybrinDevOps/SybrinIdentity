//
//  PhilippinesUnifiedMultipurposeIDModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesUnifiedMultipurposeIDModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case commonReferenceNumber, surname, givenName, middleName, sex, dateOfBirth, address, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.4 }
    final override var CroppingTopOffset: CGFloat { return 1.5 }
    final override var CroppingWidthOffset: CGFloat { return 5.1}
    final override var CroppingHeightOffset: CGFloat { return 3.5 }
    
    // MARK: Internal Properties
    final var CommonReferenceNumber: String?
    final var Surname: String?
    final var GivenName: String?
    final var MiddleName: String?
    final var Sex: Sex?
    final var DateOfBirth: Date?
    final var Address: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var commonReferenceNumber: String? { get { return self.CommonReferenceNumber } }
    @objc public final var surname: String? { get { return self.Surname } }
    @objc public final var givenName: String? { get { return self.GivenName } }
    @objc public final var middleName: String? { get { return self.MiddleName } }
    @objc public final var sex: Sex { get { return self.Sex ?? .Undetermined } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var address: String? { get { return self.Address } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(commonReferenceNumber, forKey: .commonReferenceNumber)
        try container.encode(surname, forKey: .surname)
        try container.encode(givenName, forKey: .givenName)
        try container.encode(middleName, forKey: .middleName)
        try container.encode(sex, forKey: .sex)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(address, forKey: .address)

        try super.encode(to: encoder)
    }
    
}
