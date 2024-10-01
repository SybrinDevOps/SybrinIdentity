//
//  SouthAfricaGreenBookModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/24.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import MLKitFaceDetection  ////import MLKit
import MLKitBarcodeScanning
import UIKit

@objc public final class SouthAfricaGreenBookModel: GreenBookModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case identityNumberDateOfBirth, identityNumberSex, identityNumberCitizenship, identityNumberADigit, identityNumberCheckDigit, wordConfidenceResults}
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.8 }
    final override var CroppingTopOffset: CGFloat { return 3.63 }
    final override var CroppingWidthOffset: CGFloat { return 3.8 }
    final override var CroppingHeightOffset: CGFloat { return 5.09 }
    
    // MARK: Internal Properties
    final var SouthAfricaIdentityNumber: SouthAfricaIdentityNumber?
    final override var IdentityNumber: String? { get { return SouthAfricaIdentityNumber?.IdentityNumber } set { SouthAfricaIdentityNumber = SouthAfricaIdentityNumberParser.ParseIdentityNumber(newValue ?? "") } }
    
    final var WordConfidenceResults: Dictionary<String, Any>?
    
    // MARK: Public Properties
    @objc public final var identityNumberDateOfBirth: Date? { get { return self.SouthAfricaIdentityNumber?.DateOfBirth } }
    @objc public final var identityNumberSex: Sex { get { return self.SouthAfricaIdentityNumber?.Sex ?? .Undetermined } }
    @objc public final var identityNumberCitizenship: CitizenshipType { get { return self.SouthAfricaIdentityNumber?.Citizenship ?? .Unknown } }
    @objc public final var identityNumberADigit: Int { get { return self.SouthAfricaIdentityNumber?.ADigit ?? -1 } }
    @objc public final var identityNumberCheckDigit: Int { get { return self.SouthAfricaIdentityNumber?.CheckDigit ?? -1 } }
    
    @objc public final var wordConfidenceResults: Dictionary<String, Any>? { get { return self.WordConfidenceResults } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identityNumberDateOfBirth, forKey: .identityNumberDateOfBirth)
        try container.encode(identityNumberSex, forKey: .identityNumberSex)
        try container.encode(identityNumberCitizenship, forKey: .identityNumberCitizenship)
        try container.encode(identityNumberADigit, forKey: .identityNumberADigit)
        try container.encode(identityNumberCheckDigit, forKey: .identityNumberCheckDigit)

        try super.encode(to: encoder)
    }
    
}
