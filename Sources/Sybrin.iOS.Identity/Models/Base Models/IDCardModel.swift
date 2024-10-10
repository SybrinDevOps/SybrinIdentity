//
//  IDCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public class IDCardModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case fullName, sex, nationality, identityNumber, dateOfBirth, portraitBackImagePath, documentBackImagePath, croppedDocumentBackImagePath }
    
    // MARK: Internal Properties
    var FullName: String?
    var Sex: Sex?
    var Nationality: String?
    var IdentityNumber: String?
    var DateOfBirth: Date?
    
    var CroppingBackLeftOffset: CGFloat { return 0 }
    var CroppingBackTopOffset: CGFloat { return 0 }
    var CroppingBackWidthOffset: CGFloat { return 1 }
    var CroppingBackHeightOffset: CGFloat { return 1 }
    
    var PortraitBackImage: UIImage?
    var DocumentBackImage: UIImage?
    var CroppedDocumentBackImage: UIImage?
    
    var PortraitBackImagePath: String?
    var DocumentBackImagePath: String?
    var CroppedDocumentBackImagePath: String?
    
    // MARK: Public Properties
    @objc public var fullName: String? { get { return FullName } }
    @objc public var sex: Sex { get { return Sex ?? .Undetermined } }
    @objc public var nationality: String? { get { return Nationality } }
    @objc public var identityNumber: String? { get { return IdentityNumber } }
    @objc public var dateOfBirth: Date? { get { return DateOfBirth } }
    
    @objc public var portraitBackImage: UIImage? { get { return PortraitBackImage } }
    @objc public var documentBackImage: UIImage? { get { return DocumentBackImage } }
    @objc public var croppedDocumentBackImage: UIImage? { get { return CroppedDocumentBackImage } }
    
    @objc public var portraitBackImagePath: String? { get { return PortraitBackImagePath } }
    @objc public var documentBackImagePath: String? { get { return DocumentBackImagePath } }
    @objc public var croppedDocumentBackImagePath: String? { get { return CroppedDocumentBackImagePath } }
    
    // MARK: Public Methods
    @objc public override func saveImages() {
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
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fullName, forKey: .fullName)
        try container.encode(sex, forKey: .sex)
        try container.encode(nationality, forKey: .nationality)
        try container.encode(identityNumber, forKey: .identityNumber)
        try container.encode(dateOfBirth, forKey: .dateOfBirth)
        try container.encode(portraitBackImagePath, forKey: .portraitBackImagePath)
        try container.encode(documentBackImagePath, forKey: .documentBackImagePath)
        try container.encode(croppedDocumentBackImagePath, forKey: .croppedDocumentBackImagePath)
        
        try super.encode(to: encoder)
    }
    
}
