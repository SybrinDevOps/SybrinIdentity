//
//  SAPassportResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/10/15.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct SAPassportResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedSAPassportData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedSAPassportData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedSAPassportData: Codable {
    let Surname: String?
    let Names: String?
    let IdentityNumber: String?
    let PassportNumber: String?
    let IdentityNumberADigit: Int?
    let PassportNumberCheckDigit: Int?
    let IdentityNumberCheckDigit: Int?
    let Nationality: String?
    let DateOfBirthCheckDigit: Int?
    let IdentityNumberSex: String?
    let WordConfidenceResults: String?
    let IdentityNumberCitizenship: String?
    let DateOfBirth: String?
    let IssuingCountryCode: String?
    let DateOfExpiry: String?
    let DateOfExpiryCheckDigit: Int?
    let IdentityNumberPassportCheckDigit: Int?
    let CompositeCheckDigit: Int?
    let PassportType: String?
}
