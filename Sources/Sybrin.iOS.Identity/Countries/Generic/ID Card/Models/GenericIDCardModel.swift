//
//  GenericIDCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/20.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
import UIKit
import Sybrin_iOS_Common

@objc public final class GenericIDCardModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case frontResult, backResult, documentBackImagePath }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 1000 }
    final override var CroppingTopOffset: CGFloat { return 1000 }
    final override var CroppingWidthOffset: CGFloat { return 1000 }
    final override var CroppingHeightOffset: CGFloat { return 1000 }
    
    // MARK: Internal Properties
    final var FrontResult: String?
    final var BackResult: String?
    
    var DocumentBackImage: UIImage?
    var DocumentBackImagePath: String?
    
    // MARK: Public Properties
    @objc public final var frontResult: String? { get { return self.FrontResult } }
    @objc public final var backResult: String? { get { return self.BackResult } }
    @objc public final var documentBackImage: UIImage? { get { return self.DocumentBackImage } }
    @objc public final var documentBackImagePath: String? { get { return self.DocumentBackImagePath } }
    
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
    
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(frontResult, forKey: .frontResult)
        try container.encode(backResult, forKey: .backResult)
        try container.encode(documentBackImagePath, forKey: .documentBackImagePath)

        try super.encode(to: encoder)
    }
}

