//
//  DocumentModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public class DocumentModel: NSObject, Encodable {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case portraitImagePath, documentImagePath, croppedDocumentImagePath }
    
    // MARK: Internal Properties
    var CroppingLeftOffset: CGFloat { return 0 }
    var CroppingTopOffset: CGFloat { return 0 }
    var CroppingWidthOffset: CGFloat { return 1 }
    var CroppingHeightOffset: CGFloat { return 1 }
    
    var PortraitImage: UIImage?
    var DocumentImage: UIImage?
    var CroppedDocumentImage: UIImage?

    var PortraitImagePath: String?
    var DocumentImagePath: String?
    var CroppedDocumentImagePath: String?
    
    // MARK: Public Properties
    @objc public var portraitImage: UIImage? { get { return PortraitImage } }
    @objc public var documentImage: UIImage? { get { return DocumentImage } }
    @objc public var croppedDocumentImage: UIImage? { get { return CroppedDocumentImage } }

    @objc public var portraitImagePath: String? { get { return PortraitImagePath } }
    @objc public var documentImagePath: String? { get { return DocumentImagePath } }
    @objc public var croppedDocumentImagePath: String? { get { return CroppedDocumentImagePath } }
    
    // MARK: Public Methods
    @objc public func saveImages() {
        let prefix = UUID().uuidString
            
        "Saving images".log(.Debug)
        
        if let portraitImage = PortraitImage {
            GalleryHandler.saveImage(portraitImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_PortraitImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.PortraitImagePath = path
            }
        }
        
        if let documentImage = DocumentImage {
            GalleryHandler.saveImage(documentImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_DocumentImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.DocumentImagePath = path
            }
        }
        
        if let croppedDocumentImage = CroppedDocumentImage {
            GalleryHandler.saveImage(croppedDocumentImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_CroppedDocumentImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.CroppedDocumentImagePath = path
            }
        }
        
        "Saving images done".log(.Debug)

    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(portraitImagePath, forKey: .portraitImagePath)
        try container.encode(documentImagePath, forKey: .documentImagePath)
        try container.encode(croppedDocumentImagePath, forKey: .croppedDocumentImagePath)
    }
    
}
