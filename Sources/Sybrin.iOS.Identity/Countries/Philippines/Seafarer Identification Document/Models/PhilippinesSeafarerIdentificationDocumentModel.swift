//
//  PhilippinesSeafarerIdentificationDocumentModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public final class PhilippinesSeafarerIdentificationDocumentModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case mrzLine1, mrzLine2, mrzLine3, documentType, issuingCountryCode, identityNumber, identityNumberCheckDigit, optionalData1, dateOfBirth, dateOfBirthCheckDigit, sex, dateOfExpiry, dateOfExpiryCheckDigit, nationality, optionalData2, compositeCheckDigit, surname, names, portraitBackImagePath, documentBackImagePath, croppedDocumentBackImagePath, WordConfidenceResults }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.2 }
    final override var CroppingTopOffset: CGFloat { return 0.8 }
    final override var CroppingWidthOffset: CGFloat { return 3.8 }
    final override var CroppingHeightOffset: CGFloat { return 2.3 }
    
    // MARK: Internal Properties
    final var MRZLine1: String?
    final var MRZLine2: String?
    final var MRZLine3: String?
    final var DocumentType: String?
    final var IssuingCountryCode: String?
    final var IdentityNumber: String?
    final var IdentityNumberCheckDigit: Int?
    final var OptionalData1: String?
    final var DateOfBirth: Date?
    final var DateOfBirthCheckDigit: Int?
    final var Sex: Sex?
    final var DateOfExpiry: Date?
    final var DateOfExpiryCheckDigit: Int?
    final var Nationality: String?
    final var OptionalData2: String?
    final var CompositeCheckDigit: Int?
    final var Surname: String?
    final var Names: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    final var CroppingBackLeftOffset: CGFloat { return 8.7 }
    final var CroppingBackTopOffset: CGFloat { return 0.9 }
    final var CroppingBackWidthOffset: CGFloat { return 11 }
    final var CroppingBackHeightOffset: CGFloat { return 4.2 }
    
    final var PortraitBackImage: UIImage?
    final var DocumentBackImage: UIImage?
    final var CroppedDocumentBackImage: UIImage?
    
    final var PortraitBackImagePath: String?
    final var DocumentBackImagePath: String?
    final var CroppedDocumentBackImagePath: String?
    
    // MARK: Public Properties
    @objc public final var mrzLine1: String? { get { return self.MRZLine1 } }
    @objc public final var mrzLine2: String? { get { return self.MRZLine2 } }
    @objc public final var mrzLine3: String? { get { return self.MRZLine3 } }
    @objc public final var documentType: String? { get { return self.DocumentType } }
    @objc public final var issuingCountryCode: String? { get { return self.IssuingCountryCode } }
    @objc public final var identityNumber: String? { get { return self.IdentityNumber } }
    @objc public final var identityNumberCheckDigit: Int { get { return self.IdentityNumberCheckDigit ?? -1 } }
    @objc public final var optionalData1: String? { get { return self.OptionalData1 } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var dateOfBirthCheckDigit: Int { get { return self.DateOfBirthCheckDigit ?? -1 } }
    @objc public final var sex: Sex { get { return self.Sex ?? .Undetermined } }
    @objc public final var dateOfExpiry: Date? { get { return self.DateOfExpiry } }
    @objc public final var dateOfExpiryCheckDigit: Int { get { return self.DateOfExpiryCheckDigit ?? -1 } }
    @objc public final var nationality: String? { get { return self.Nationality } }
    @objc public final var optionalData2: String? { get { return self.OptionalData2 } }
    @objc public final var compositeCheckDigit: Int { get { return self.CompositeCheckDigit ?? -1 } }
    @objc public final var surname: String? { get { return self.Surname } }
    @objc public final var names: String? { get { return self.Names } }
    
    @objc public final var portraitBackImage: UIImage? { get { return self.PortraitBackImage } }
    @objc public final var documentBackImage: UIImage? { get { return self.DocumentBackImage } }
    @objc public final var croppedDocumentBackImage: UIImage? { get { return self.CroppedDocumentBackImage } }
    
    @objc public final var portraitBackImagePath: String? { get { return self.PortraitBackImagePath } }
    @objc public final var documentBackImagePath: String? { get { return self.DocumentBackImagePath } }
    @objc public final var croppedDocumentBackImagePath: String? { get { return self.CroppedDocumentBackImagePath } }
    
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    @objc final public override func saveImages() {
        let prefix = UUID().uuidString
        
        super.saveImages()
            
        "Saving images".log(.Debug)
        
        if let portraitBackImage = PortraitBackImage {
            GalleryHandler.saveImage(portraitBackImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_PortraitBackImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.PortraitBackImagePath = path
            }
        }
        
        if let documentBackImage = DocumentBackImage {
            GalleryHandler.saveImage(documentBackImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_DocumentBackImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.DocumentBackImagePath = path
            }
        }
        
        if let croppedDocumentBackImage = CroppedDocumentBackImage {
            GalleryHandler.saveImage(croppedDocumentBackImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_CroppedDocumentBackImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.CroppedDocumentBackImagePath = path
            }
        }
        
        "Saving images done".log(.Debug)

    }
    
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mrzLine1, forKey: .mrzLine1)
        try container.encode(mrzLine2, forKey: .mrzLine2)
        try container.encode(mrzLine3, forKey: .mrzLine3)
        try container.encode(documentType, forKey: .documentType)
        try container.encode(issuingCountryCode, forKey: .issuingCountryCode)
        try container.encode(identityNumber, forKey: .identityNumber)
        try container.encode(identityNumberCheckDigit, forKey: .identityNumberCheckDigit)
        try container.encode(optionalData1, forKey: .optionalData1)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(dateOfBirthCheckDigit, forKey: .dateOfBirthCheckDigit)
        try container.encode(sex, forKey: .sex)
        try container.encode(dateOfExpiry, forKey: .dateOfExpiry)
        try container.encode(dateOfExpiryCheckDigit, forKey: .dateOfExpiryCheckDigit)
        try container.encode(nationality, forKey: .nationality)
        try container.encode(optionalData2, forKey: .optionalData2)
        try container.encode(compositeCheckDigit, forKey: .compositeCheckDigit)
        try container.encode(surname, forKey: .surname)
        try container.encode(names, forKey: .names)
        try container.encode(portraitBackImagePath, forKey: .portraitBackImagePath)
        try container.encode(documentBackImagePath, forKey: .documentBackImagePath)
        try container.encode(croppedDocumentBackImagePath, forKey: .croppedDocumentBackImagePath)

        try super.encode(to: encoder)
    }
    
}
