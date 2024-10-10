//
//  SouthAfricaRetirementVisaModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/01.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class SouthAfricaRetiredPersonVisaModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case names, passportNumber, numberOfEntries, validFrom, referenceNumber, dateOfExpiry, issuedAt, controlNumber, barcodeData }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 5.1 }
    final override var CroppingTopOffset: CGFloat { return 8 }
    final override var CroppingWidthOffset: CGFloat { return 6 }
    final override var CroppingHeightOffset: CGFloat { return 9.5 }
    
    // MARK: Internal Properties
    final var Names: String?
    final var PassportNumber: String? 
    final var NumberOfEntries: String?
    final var ValidFrom: Date?
    final var ReferenceNumber: String?
    final var DateOfExpiry: Date?
    final var IssuedAt: String?
    final var ControlNumber: String?
    final var BarcodeData: String?
    
    // MARK: Public Properties
    @objc public final var names: String? { get { return self.Names } }
    @objc public final var passportNumber: String? { get { return self.PassportNumber } }
    @objc public final var numberOfEntries: String? { get { return self.NumberOfEntries } }
    @objc public final var validFrom: Date? { get { return self.ValidFrom} }
    @objc public final var referenceNumber: String? { get { return self.ReferenceNumber } }
    @objc public final var dateOfExpiry: Date? { get { return self.DateOfExpiry } }
    @objc public final var issuedAt: String? { get { return self.IssuedAt } }
    @objc public final var controlNumber: String? { get { return self.ControlNumber } }
    @objc public final var barcodeData: String? { get { return self.BarcodeData } }
   
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(names, forKey: .names)
        try container.encode(passportNumber, forKey: .passportNumber)
        try container.encode(numberOfEntries, forKey: .numberOfEntries)
        try container.encode(validFrom, forKey: .validFrom)
        try container.encode(referenceNumber, forKey: .referenceNumber)
        try container.encode(dateOfExpiry, forKey: .dateOfExpiry)
        try container.encode(issuedAt, forKey: .issuedAt)
        try container.encode(controlNumber, forKey: .controlNumber)
        try container.encode(barcodeData, forKey: .barcodeData)

        try super.encode(to: encoder)
    }

}
