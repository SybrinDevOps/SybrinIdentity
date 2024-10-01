//
//  PhilippinesFirearmsLicenseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesFirearmsLicenseModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case fullName, licenseToOwnAndPossessFirearmNumber, qualification, dateApproved, dateExpiry, otherLicenses, address, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 1.1 }
    final override var CroppingTopOffset: CGFloat { return 3.6 }
    final override var CroppingWidthOffset: CGFloat { return 10 }
    final override var CroppingHeightOffset: CGFloat { return 6.6 }
    
    // MARK: Internal Properties
    final var FullName: String?
    final var LicenseToOwnAndPossessFirearmNumber: String?
    final var Qualification: String?
    final var DateApproved: Date?
    final var DateExpiry: Date?
    final var OtherLicenses: String?
    final var Address: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var fullName: String? { get { return self.FullName } }
    @objc public final var licenseToOwnAndPossessFirearmNumber: String? { get { return self.LicenseToOwnAndPossessFirearmNumber } }
    @objc public final var qualification: String? { get { return self.Qualification } }
    @objc public final var dateApproved: Date? { get { return self.DateApproved } }
    @objc public final var dateExpiry: Date? { get { return self.DateExpiry } }
    @objc public final var otherLicenses: String? { get { return self.OtherLicenses } }
    @objc public final var address: String? { get { return self.Address } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fullName, forKey: .fullName)
        try container.encode(licenseToOwnAndPossessFirearmNumber, forKey: .licenseToOwnAndPossessFirearmNumber)
        try container.encode(qualification, forKey: .qualification)
        try container.encode(dateApproved, forKey: .dateApproved)
        try container.encode(dateExpiry, forKey: .dateExpiry)
        try container.encode(otherLicenses, forKey: .otherLicenses)
        try container.encode(address, forKey: .address)

        try super.encode(to: encoder)
    }
    
}
