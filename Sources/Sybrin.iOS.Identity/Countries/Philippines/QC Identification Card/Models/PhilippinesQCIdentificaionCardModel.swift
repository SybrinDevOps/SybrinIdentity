//
//  PhilippinesQCIdentificaionCard.swift
//  Sybrin.iOS.Identity
//
//  Created by Matthew Dickson on 2022/11/08.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//



import UIKit


@objc public final class PhilippinesQCIdentificationCardModel: IDCardModel  {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case fullName, sex, dateOfBirth, civilStatus, bloodType, dateIssued, validUntil, disabilityType, citizenType, address, qcReferenceNumber, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 1.1 }
    final override var CroppingTopOffset: CGFloat { return 3.6 }
    final override var CroppingWidthOffset: CGFloat { return 10 }
    final override var CroppingHeightOffset: CGFloat { return 6.6 }
    
    // MARK: Internal Properties
    final var CivilStatus: String?
    final var BloodType: String?
    final var DateIssued: Date?
    final var ValidUntil: Date?
    final var DisabilityType: String?
    final var CitizenType: String?
    final var Address: String?
    final var QCReferenceNumber: String?
    final var BarcodeData: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var civilStatus: String? { get { return self.CivilStatus } }
    @objc public final var bloodType: String? { get { return self.BloodType } }
    @objc public final var dateIssued: Date? { get { return self.DateIssued } }
    @objc public final var validUntil: Date? { get { return self.ValidUntil } }
    @objc public final var disabilityType: String? { get { return self.DisabilityType } }
    @objc public final var citizenType: String? { get { return self.CitizenType } }
    @objc public final var address: String? { get { return self.Address } }
    @objc public final var qcReferenceNumber: String? { get { return self.QCReferenceNumber } }
    @objc public final var barcodeData: String? { get { return self.BarcodeData } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    


    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fullName, forKey: .fullName)
        try container.encode(sex, forKey: .sex)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(civilStatus, forKey: .civilStatus)
        try container.encode(bloodType, forKey: .bloodType)
        try container.encode(dateIssued, forKey: .dateIssued)
        try container.encode(validUntil, forKey: .validUntil)
        try container.encode(disabilityType, forKey: .disabilityType)
        try container.encode(citizenType, forKey: .citizenType)
        try container.encode(address, forKey: .address)
        try container.encode(qcReferenceNumber, forKey: .qcReferenceNumber)
        //try container.encode(wordConfidenceResults, forKey: .wordConfidenceResults)
        

        try super.encode(to: encoder)
    }
    
}
