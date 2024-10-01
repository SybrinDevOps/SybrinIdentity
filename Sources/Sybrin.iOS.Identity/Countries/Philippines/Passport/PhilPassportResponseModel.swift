//
//  PhilPassportResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct PhilPassportResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedPassportData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedPassportData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedPassportData : Codable {
    let MRZLine1: String?
    let MRZLine2: String?
    let PassportType: String?
    let IssuingCountryCode: String?
    let Surname: String?
    let Names: String?
    let PassportNumber: String?
    let PassportNumberCheckDigit: Int?
    let Nationality: String?
    let DateOfBirth: String?
    let DateOfBirthCheckDigit: Int?
    let Sex: String?
    let DateOfExpiry: String?
    let DateOfExpiryCheckDigit: Int?
    let CompositeCheckDigit: Int?
    let WordConfidenceResults: String?
    let FrontImageSecurityCheckSuccess: Bool?
    let FaceDetection: [FaceDetection]?
}
