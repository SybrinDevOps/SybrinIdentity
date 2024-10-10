//
//  DocumentDataModel.swift
//  Sybrin.iOS.DocumentScanner
//
//  Created by Default on 2021/11/29.
//

import Foundation
import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public class DataModel: NSObject, Encodable {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case originalDocumentImagePath, croppedDocumentImagePath }
    
    // MARK: Internal Properties
    var OriginalDocumentImage: UIImage?
    var CroppedDocumentImage: UIImage?

    var OriginalDocumentImagePath: String?
    var CroppedDocumentImagePath: String?
    
    // MARK: Public Properties
    @objc public var originalDocumentImage: UIImage? { get { return OriginalDocumentImage } }
    @objc public var croppedDocumentImage: UIImage? { get { return CroppedDocumentImage } }

    @objc public var originalDocumentImagePath: String? { get { return OriginalDocumentImagePath } }
    @objc public var croppedDocumentImagePath: String? { get { return CroppedDocumentImagePath } }
    
    // MARK: Public Methods
    @objc public func saveImages() {
        let prefix = UUID().uuidString
            
        "Saving images".log(.Debug)
        
        if let originalDocumentImage = OriginalDocumentImage {
            GalleryHandler.saveImage(originalDocumentImage, name: "\(prefix.replacingOccurrences(of: " ", with: ""))_PortraitImage") { [weak self] (path) in
                guard let self = self else { return }
                
                self.OriginalDocumentImagePath = path
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
        
        try container.encode(originalDocumentImagePath, forKey: .originalDocumentImagePath)
        try container.encode(croppedDocumentImagePath, forKey: .croppedDocumentImagePath)
    }
    
}
