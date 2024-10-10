//
//  GenericDocumentModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/17.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
import UIKit

@objc public final class GenericDocumentModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case result }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 1000 }
    final override var CroppingTopOffset: CGFloat { return 1000 }
    final override var CroppingWidthOffset: CGFloat { return 1000 }
    final override var CroppingHeightOffset: CGFloat { return 1000 }
    
    // MARK: Internal Properties
    final var Result: String?
    
    // MARK: Public Properties
    @objc public final var result: String? { get { return self.Result } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(result, forKey: .result)

        try super.encode(to: encoder)
    }
}

