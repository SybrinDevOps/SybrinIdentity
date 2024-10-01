//
//  PhilippinesDriversLicenseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public final class PhilippinesDriversLicenseModel: DriversLicenseModel {
    
    // MARK: Private Properties
//    private enum CodingKeys: String, CodingKey { case names, lastName, nationality, sex, dateOfBirth, weight, height, address, expirationDate, agencyCode, bloodType, eyeColor, restrictions, conditions, barcodeData, serialNumber, barcodeImagePath, croppedDocumentBackImagePath }
    
    private enum CodingKeys: String, CodingKey { case names, lastName, nationality, sex, dateOfBirth, address, expirationDate, agencyCode, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.5 }
    final override var CroppingTopOffset: CGFloat { return 1.2 }
    final override var CroppingWidthOffset: CGFloat { return 5.0 }
    final override var CroppingHeightOffset: CGFloat { return 3.2 }
    final override var CroppingBackLeftOffset: CGFloat { return 0 }
    final override var CroppingBackTopOffset: CGFloat { return 0 }
    final override var CroppingBackWidthOffset: CGFloat { return 1 }
    final override var CroppingBackHeightOffset: CGFloat { return 1 }
    
    
    // MARK: Internal Properties
    final var Names: String?
    final var LastName: String?
    final var Nationality: String?
    final var Sex: Sex?
    final var DateOfBirth: Date?
//    final var Weight: Float?
//    final var Height: Float?
    final var Address: String?
    final var ExpirationDate: Date?
    final var AgencyCode: String?
//    final var BloodType: String?
//    final var EyeColor: String?
//    final var Restrictions: String?
//    final var Conditions: String?
//
    final var BarcodeData: String?
    final var SerialNumber: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
//
//    final var BarcodeImage: UIImage?
//    final var CroppedDocumentBackImage: UIImage?
//
//    final var BarcodeImagePath: String?
//    final var CroppedDocumentBackImagePath: String?
    
    // MARK: Public Properties
    @objc public final var names: String? { get { return self.Names } }
    @objc public final var lastName: String? { get { return self.LastName } }
    @objc public final var nationality: String? { get { return self.Nationality } }
    @objc public final var sex: Sex { get { return self.Sex ?? .Undetermined } }
    @objc public final var dateOfBirth: Date? { get { return self.DateOfBirth } }
//    @objc public final var weight: Float { get { return self.Weight ?? -1 } }
//    @objc public final var height: Float { get { return self.Height ?? -1 } }
    @objc public final var address: String? { get { return self.Address } }
    @objc public final var expirationDate: Date? { get { return self.ExpirationDate } }
    @objc public final var agencyCode: String? { get { return self.AgencyCode } }
//    @objc public final var bloodType: String? { get { return self.BloodType } }
//    @objc public final var eyeColor: String? { get { return self.EyeColor } }
//    @objc public final var restrictions: String? { get { return self.Restrictions } }
//    @objc public final var conditions: String? { get { return self.Conditions } }
    
//    @objc public final var barcodeData: String? { get { return self.BarcodeData } }
//    @objc public final var serialNumber: String? { get { return self.SerialNumber } }
    
    @objc public final var fullName: String? { get { return "\(self.Names ?? "") \(self.LastName ?? "")" } }
    
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    
//    @objc public final var barcodeImage: UIImage? { get { return BarcodeImage } }
//    @objc public final var croppedDocumentBackImage: UIImage? { get { return CroppedDocumentBackImage } }
    
//    @objc public final var barcodeImagePath: String? { get { return BarcodeImagePath } }
//    @objc public final var croppedDocumentBackImagePath: String? { get { return CroppedDocumentBackImagePath } }
    
    // MARK: Public Methods
    @objc public final override func saveImages() {
//        let prefix = UUID().uuidString
        
        super.saveImages()
            
        "Saving images".log(.Debug)
        
//        if let barcodeImage = BarcodeImage {
//            GalleryHandler.saveImage(barcodeImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_BarcodeImage") { [weak self] (path) in
//                guard let self = self else { return }
//
//                self.BarcodeImagePath = path
//            }
//        }
//
//        if let croppedDocumentBackImage = CroppedDocumentBackImage {
//            GalleryHandler.saveImage(croppedDocumentBackImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_CroppedDocumentBackImage") { [weak self] (path) in
//                guard let self = self else { return }
//
//                self.CroppedDocumentBackImagePath = path
//            }
//        }
        
        "Saving images done".log(.Debug)

    }
    
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(names, forKey: .names)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(nationality, forKey: .nationality)
        try container.encode(sex, forKey: .sex)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
//        try container.encode(weight, forKey: .weight)
//        try container.encode(height, forKey: .height)
        try container.encode(address, forKey: .address)
        try container.encode(expirationDate, forKey: .expirationDate)
        try container.encode(agencyCode, forKey: .agencyCode)
//        try container.encode(bloodType, forKey: .bloodType)
//        try container.encode(eyeColor, forKey: .eyeColor)
//        try container.encode(restrictions, forKey: .restrictions)
//        try container.encode(conditions, forKey: .conditions)
//        try container.encode(barcodeData, forKey: .barcodeData)
//        try container.encode(serialNumber, forKey: .serialNumber)
//        try container.encode(barcodeImagePath, forKey: .barcodeImagePath)
//        try container.encode(croppedDocumentBackImagePath, forKey: .croppedDocumentBackImagePath)

        try super.encode(to: encoder)
    }
    
}
