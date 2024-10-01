//
//  SouthAfricaDriversLicenseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public final class SouthAfricaDriversLicenseModel: DriversLicenseModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey {
        case identityNumberDateOfBirth, identityNumberSex, identityNumberCitizenship, identityNumberADigit, identityNumberCheckDigit, initials, surname, sex, dateOfBirth, vehicleCodes, prdpCode, idCountryOfIssue, licenseCountryOfIssue, vehicleRestrictions, idNumberType, driverRestrictions, prdpExpiry, licenseIssueNumber, validFrom, validTo, issueDates, barcodeImagePath, croppedDocumentBackImagePath }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 5.2 }
    final override var CroppingTopOffset: CGFloat { return 1.1 }
    final override var CroppingWidthOffset: CGFloat { return 6.8 }
    final override var CroppingHeightOffset: CGFloat { return 4.5 }
    final override var CroppingBackLeftOffset: CGFloat { return 0.1 }
    final override var CroppingBackTopOffset: CGFloat { return 0.2 }
    final override var CroppingBackWidthOffset: CGFloat { return 1.2 }
    final override var CroppingBackHeightOffset: CGFloat { return 3.1 }
    
    // MARK: Internal Properties
    final var BarcodeDataEncrypted: [UInt8]?
    final var BarcodeDataDecrypted: [UInt8]?
    
    final var IdentityNumber: SouthAfricaIdentityNumber?
    final var Initials: String?
    final var Surname: String?
    final var Sex: Sex?
    final var DateOfBirth: Date?
    final var VehicleCodes: [String]?
    final var PRDPCode: String?
    final var IDCountryOfIssue: String?
    final var LicenseCountryOfIssue: String?
    final var VehicleRestrictions: [String]?
    final var IDNumberType: String?
    final var DriverRestrictions: String?
    final var PRDPExpiry: Date?
    final var LicenseIssueNumber: String?
    final var ValidFrom: Date?
    final var ValidTo: Date?
    final var IssueDates: [Date]?
    
    final var BarcodeImage: UIImage?
    final var CroppedDocumentBackImage: UIImage?
    
    final var BarcodeImagePath: String?
    final var CroppedDocumentBackImagePath: String?
    
    // MARK: Public Properties
    @objc public final var identityNumber: String? { get { return self.IdentityNumber?.IdentityNumber } }
    @objc public final var identityNumberDateOfBirth: Date? { get { return self.IdentityNumber?.DateOfBirth } }
    @objc public final var identityNumberSex: Sex { get { return self.IdentityNumber?.Sex ?? .Undetermined } }
    @objc public final var identityNumberCitizenship: CitizenshipType { get { return self.IdentityNumber?.Citizenship ?? .Unknown } }
    @objc public final var identityNumberADigit: Int { get { return self.IdentityNumber?.ADigit ?? -1 } }
    @objc public final var identityNumberCheckDigit: Int { get { return self.IdentityNumber?.CheckDigit ?? -1 } }
    @objc public final var initials: String? { get { return self.Initials } }
    @objc public final var surname: String? { get { return self.Surname } }
    @objc public final var sex: Sex { get { return self.Sex ?? .Undetermined } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
    @objc public final var vehicleCodes: [String]? { get { return self.VehicleCodes } }
    @objc public final var prdpCode: String? { get { return self.PRDPCode } }
    @objc public final var idCountryOfIssue: String? { get { return self.IDCountryOfIssue } }
    @objc public final var licenseCountryOfIssue: String? { get { return self.LicenseCountryOfIssue } }
    @objc public final var vehicleRestrictions: [String]? { get { return self.VehicleRestrictions } }
    @objc public final var idNumberType: String? { get { return self.IDNumberType } }
    @objc public final var driverRestrictions: String? { get { return self.DriverRestrictions } }
    @objc public final var prdpExpiry: Date? { get { return self.PRDPExpiry } }
    @objc public final var licenseIssueNumber: String? { get { return self.LicenseIssueNumber } }
    @objc public final var validFrom: Date? { get { return self.ValidFrom } }
    @objc public final var validTo: Date? { get { return self.ValidTo } }
    @objc public final var issueDates: [Date]? { get { return self.IssueDates } }
    
    @objc public final var barcodeImage: UIImage? { get { return BarcodeImage } }
    @objc public final var croppedDocumentBackImage: UIImage? { get { return CroppedDocumentBackImage } }
    
    @objc public final var barcodeImagePath: String? { get { return BarcodeImagePath } }
    @objc public final var croppedDocumentBackImagePath: String? { get { return CroppedDocumentBackImagePath } }
    
    // MARK: Public Methods
    @objc public final override func saveImages() {
        let prefix = UUID().uuidString
        
        super.saveImages()
            
        "Saving images".log(.Debug)
        
        if let barcodeImage = BarcodeImage {
            GalleryHandler.saveImage(barcodeImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_BarcodeImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.BarcodeImagePath = path
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
        
        try container.encode(identityNumberDateOfBirth, forKey: .identityNumberDateOfBirth)
        try container.encode(identityNumberSex, forKey: .identityNumberSex)
        try container.encode(identityNumberCitizenship, forKey: .identityNumberCitizenship)
        try container.encode(identityNumberADigit, forKey: .identityNumberADigit)
        try container.encode(identityNumberCheckDigit, forKey: .identityNumberCheckDigit)
        try container.encode(initials, forKey: .initials)
        try container.encode(surname, forKey: .surname)
        try container.encode(sex, forKey: .sex)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(vehicleCodes, forKey: .vehicleCodes)
        try container.encode(prdpCode, forKey: .prdpCode)
        try container.encode(idCountryOfIssue, forKey: .idCountryOfIssue)
        try container.encode(licenseCountryOfIssue, forKey: .licenseCountryOfIssue)
        try container.encode(vehicleRestrictions, forKey: .vehicleRestrictions)
        try container.encode(idNumberType, forKey: .idNumberType)
        try container.encode(driverRestrictions, forKey: .driverRestrictions)
        try container.encode(prdpExpiry, forKey: .prdpExpiry)
        try container.encode(licenseIssueNumber, forKey: .licenseIssueNumber)
        try container.encode(validFrom, forKey: .validFrom)
        try container.encode(validTo, forKey: .validTo)
        try container.encode(issueDates, forKey: .issueDates)
        try container.encode(barcodeImagePath, forKey: .barcodeImagePath)
        try container.encode(croppedDocumentBackImagePath, forKey: .croppedDocumentBackImagePath)

        try super.encode(to: encoder)
    }
    
}
