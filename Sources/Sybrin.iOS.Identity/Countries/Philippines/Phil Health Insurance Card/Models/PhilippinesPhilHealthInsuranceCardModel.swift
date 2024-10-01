//
//  PhilippinesPhilHealthInsuranceCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesPhilHealthInsuranceCardModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case philHealthNumber, fullName, dateOfBirth, sex, address, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.6 }
    final override var CroppingTopOffset: CGFloat { return 1.4 }
    final override var CroppingWidthOffset: CGFloat { return 5 }
    final override var CroppingHeightOffset: CGFloat { return 3.1 }
    
    // MARK: Internal Properties
    final var PhilHealthNumber: String?
    final var FullName: String?
    final var DateOfBirth: Date?
    final var Sex: Sex?
    final var Address: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var philHealthNumber: String? { get { return self.PhilHealthNumber } }
    @objc public final var fullName: String? { get { return self.FullName } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var sex: Sex { get { return self.Sex ?? .Undetermined } }
    @objc public final var address: String? { get { return self.Address } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(philHealthNumber, forKey: .philHealthNumber)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(sex, forKey: .sex)
        try container.encode(address, forKey: .address)

        try super.encode(to: encoder)
    }
    
}
