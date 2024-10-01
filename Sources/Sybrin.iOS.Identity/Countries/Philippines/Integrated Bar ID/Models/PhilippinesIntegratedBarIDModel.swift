//
//  PhilippinesIntegratedBarIDModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class PhilippinesIntegratedBarIDModel: DocumentModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case fullName, rollOfAttorneysNumber, integratedBarPhilippinesChapter, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 4.7 }
    final override var CroppingTopOffset: CGFloat { return 1.3 }
    final override var CroppingWidthOffset: CGFloat { return 6.3 }
    final override var CroppingHeightOffset: CGFloat { return 4.1 }
    
    // MARK: Internal Properties
    final var FullName: String?
    final var RollOfAttorneysNumber: String?
    final var IntegratedBarPhilippinesChapter: String?
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var fullName: String? { get { return self.FullName } }
    @objc public final var rollOfAttorneysNumber: String? { get { return self.RollOfAttorneysNumber } }
    @objc public final var integratedBarPhilippinesChapter: String? { get { return self.IntegratedBarPhilippinesChapter } }
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(fullName, forKey: .fullName)
        try container.encode(rollOfAttorneysNumber, forKey: .rollOfAttorneysNumber)
        try container.encode(integratedBarPhilippinesChapter, forKey: .integratedBarPhilippinesChapter)

        try super.encode(to: encoder)
    }
    
}
