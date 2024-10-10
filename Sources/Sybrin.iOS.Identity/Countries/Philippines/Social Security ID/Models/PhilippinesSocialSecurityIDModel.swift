//
//  PhilippinesSocialSecurityIDModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesSocialSecurityIDModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case socialSecurityNumber, fullName, dateOfBirth, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.85 }
    final override var CroppingTopOffset: CGFloat { return 1.35 }
    final override var CroppingWidthOffset: CGFloat { return 6.4 }
    final override var CroppingHeightOffset: CGFloat { return 3.8 }
    
    // MARK: Internal Properties
    final var SocialSecurityNumber: String?
    final var FullName: String?
    final var DateOfBirth: Date?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var socialSecurityNumber: String? { get { return self.SocialSecurityNumber } }
    @objc public final var fullName: String? { get { return self.FullName } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(socialSecurityNumber, forKey: .socialSecurityNumber)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)

        try super.encode(to: encoder)
    }
    
}
