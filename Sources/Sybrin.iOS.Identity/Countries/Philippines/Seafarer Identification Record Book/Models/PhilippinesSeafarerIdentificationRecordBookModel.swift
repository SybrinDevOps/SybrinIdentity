//
//  PhilippinesSeafarerIdentificationRecordBookModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesSeafarerIdentificationRecordBookModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case fullName, dateOfBirth, placeOfBirth, height, weight, eyeColor, hairColor, distinguishingMarks, sex, dateOfIssue, placeOfIssue, validUntil, documentNumber, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.6 }
    final override var CroppingTopOffset: CGFloat { return 1 }
    final override var CroppingWidthOffset: CGFloat { return 5.5 }
    final override var CroppingHeightOffset: CGFloat { return 3.2 }
    
    // MARK: Internal Properties
    final var FullName: String?
    final var DateOfBirth: Date?
    final var PlaceOfBirth: String?
    final var Height: Float?
    final var Weight: Float?
    final var EyeColor: String?
    final var HairColor: String?
    final var DistinguishingMarks: String?
    final var Sex: Sex?
    final var DateOfIssue: Date?
    final var PlaceOfIssue: String?
    final var ValidUntil: Date?
    final var DocumentNumber: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var fullName: String? { get { return self.FullName } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var placeOfBirth: String? { get { return self.PlaceOfBirth } }
    @objc public final var height: Float { get { return self.Height ?? -1 } }
    @objc public final var weight: Float { get { return self.Weight ?? -1 } }
    @objc public final var eyeColor: String? { get { return self.EyeColor } }
    @objc public final var hairColor: String? { get { return self.HairColor } }
    @objc public final var distinguishingMarks: String? { get { return self.DistinguishingMarks } }
    @objc public final var sex: Sex { get { return self.Sex ?? .Undetermined } }
    @objc public final var dateOfIssue: Date? { get { return self.DateOfIssue } }
    @objc public final var placeOfIssue: String? { get { return self.PlaceOfIssue } }
    @objc public final var validUntil: Date? { get { return self.ValidUntil } }
    @objc public final var documentNumber: String? { get { return self.DocumentNumber } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fullName, forKey: .fullName)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(placeOfBirth, forKey: .placeOfBirth)
        try container.encode(height, forKey: .height)
        try container.encode(weight, forKey: .weight)
        try container.encode(eyeColor, forKey: .eyeColor)
        try container.encode(hairColor, forKey: .hairColor)
        try container.encode(distinguishingMarks, forKey: .distinguishingMarks)
        try container.encode(sex, forKey: .sex)
        try container.encode(dateOfIssue, forKey: .dateOfIssue)
        try container.encode(placeOfIssue, forKey: .placeOfIssue)
        try container.encode(validUntil, forKey: .validUntil)
        try container.encode(documentNumber, forKey: .documentNumber)

        try super.encode(to: encoder)
    }
    
}
