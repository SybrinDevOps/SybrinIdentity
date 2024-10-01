//
//  PhilippinesProfessionalRegulationCommissionCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesProfessionalRegulationCommissionCardModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case lastName, firstName, middleInitialName, registrationNumber, registrationDate, validUntil, profession, dateOfBirth, dateIssued, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 3.5 }
    final override var CroppingTopOffset: CGFloat { return 1.1 }
    final override var CroppingWidthOffset: CGFloat { return 5.2 }
    final override var CroppingHeightOffset: CGFloat { return 3.1}
    
    // MARK: Internal Properties
    final var LastName: String?
    final var FirstName: String?
    final var MiddleInitialName: String?
    final var RegistrationNumber: String?
    final var RegistrationDate: Date?
    final var ValidUntil: Date?
    final var Profession: String?
    final var DateOfBirth: Date?
    final var DateIssued: Date?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var lastName: String? { get { return self.LastName } }
    @objc public final var firstName: String? { get { return self.FirstName } }
    @objc public final var middleInitialName: String? { get { return self.MiddleInitialName } }
    @objc public final var registrationNumber: String? { get { return self.RegistrationNumber } }
    @objc public final var registrationDate: Date? { get { return self.RegistrationDate } }
    @objc public final var validUntil: Date? { get { return self.ValidUntil } }
    @objc public final var profession: String? { get { return self.Profession } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var dateIssued: Date? { get { return self.DateIssued } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(lastName, forKey: .lastName)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(middleInitialName, forKey: .middleInitialName)
        try container.encode(registrationNumber, forKey: .registrationNumber)
        try container.encode(registrationDate, forKey: .registrationDate)
        try container.encode(validUntil, forKey: .validUntil)
        try container.encode(profession, forKey: .profession)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(dateIssued, forKey: .dateIssued)

        try super.encode(to: encoder)
    }
    
}
