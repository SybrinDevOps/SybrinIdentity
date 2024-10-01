//
//  DriversLicenseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public class DriversLicenseModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case licenseNumber, documentBackImagePath }
    
    // MARK: Internal Properties
    var LicenseNumber: String?
    
    var CroppingBackLeftOffset: CGFloat { return 0 }
    var CroppingBackTopOffset: CGFloat { return 0 }
    var CroppingBackWidthOffset: CGFloat { return 1 }
    var CroppingBackHeightOffset: CGFloat { return 1 }
    
    var DocumentBackImage: UIImage?
    
    var DocumentBackImagePath: String?
    
    // MARK: Public Properties
    @objc public var licenseNumber: String? { get { return LicenseNumber } }
    
    @objc public var documentBackImage: UIImage? { get { return DocumentBackImage } }
    
    @objc public var documentBackImagePath: String? { get { return DocumentBackImagePath } }
    
    // MARK: Public Methods
    @objc public override func saveImages() {
        let prefix = UUID().uuidString
        
        super.saveImages()
            
        "Saving images".log(.Debug)
        
        if let documentBackImage = DocumentBackImage {
            GalleryHandler.saveImage(documentBackImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_DocumentBackImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.DocumentBackImagePath = path
            }
        }
        
        "Saving images done".log(.Debug)

    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(licenseNumber, forKey: .licenseNumber)
        try container.encode(documentBackImagePath, forKey: .documentBackImagePath)
        
        try super.encode(to: encoder)
    }
    
}
