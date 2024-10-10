//
//  PhilippinesIdentificationCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Default on 2022/05/04.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public final class PhilippinesIdentificationCardModel: IDCardModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case address, bloodType, commonReferenceNumber, idDateOfBirth, dateOfIssued, givenNames, lastName, maritalStatus, middleName, placeOfBirth, idSex, wordConfidenceResults
    }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 1 }
    final override var CroppingTopOffset: CGFloat { return 1.5 }
    final override var CroppingWidthOffset: CGFloat { return 7.7 }
    final override var CroppingHeightOffset: CGFloat { return 4 }
    
    // MARK: Internal Properties
    final var Address: String?
    final var BloodType: String?
    final var CommonReferenceNumber: String?
    final var DateOfIssued: Date?
    final var GivenNames: String?
    final var LastName: String?
    final var MaritalStatus: String?
    final var MiddleName: String?
    final var PlaceOfBirth: String?
    final var IdSex: Sex?
    final var IdDateOfBirth: Date?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    
    final var BarcodeImage: UIImage?
    
    final var BarcodeImagePath: String?
    
    // MARK: Public Properties
    @objc public final override var fullName: String? { get { return "\(self.GivenNames ?? "") \(self.LastName ?? "")" } }
    
    @objc public final var address: String? { get { return self.Address } }
    @objc public final var bloodType: String? { get { return self.BloodType } }
    @objc public final var commonReferenceNumber: String? { get { return self.CommonReferenceNumber } }
    @objc public final var dateOfIssued: Date? { get { return self.DateOfIssued } }
    @objc public final var givenNames: String? { get { return self.GivenNames } }
    @objc public final var lastName: String? { get { return self.LastName } }
    @objc public final var maritalStatus: String? { get { return self.MiddleName } }
    @objc public final var middleName: String? { get { return self.MaritalStatus } }
    @objc public final var placeOfBirth: String? { get { return self.PlaceOfBirth } }
    
    @objc public final var idSex: Sex { get { return self.IdSex ?? .Undetermined } }
    @objc public final var idDateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    @objc public final override func saveImages() {
        super.saveImages()
            
        "Saving images".log(.Debug)
        
        "Saving images done".log(.Debug)
    }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(address, forKey: .address)
        try container.encode(bloodType, forKey: .bloodType)
        try container.encode(commonReferenceNumber, forKey: .commonReferenceNumber)
        try container.encode(idDateOfBirth, forKey: .idDateOfBirth)
        try container.encode(dateOfIssued, forKey: .dateOfIssued)
        try container.encode(givenNames, forKey: .givenNames)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(maritalStatus, forKey: .maritalStatus)
        try container.encode(middleName, forKey: .middleName)
        try container.encode(placeOfBirth, forKey: .placeOfBirth)
        try container.encode(idSex, forKey: .idSex)
        //try container.encode(wordConfidenceResults, forKey: .wordConfidenceResults)
        
        try super.encode(to: encoder)
    }
}
