//
//  SAIDCardResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/10/15.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct SAIDCardResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedSAIDData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedSAIDData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedSAIDData: Codable {
    let Surname: String?
    let Names: String?
    let IdentityNumber: String?
    let IdentityNumberADigit: Int?
    let IdentityNumberCheckDigit: Int?
    let Nationality: String?
    let DateOfBirthCheckDigit: Int?
    let IdentityNumberSex: String?
    let WordConfidenceResults: String?
    let BackImageSecurityCheckSuccess: Bool?
    let DocumentValidationType: String?
    let DocumentValidationStatus: String?
    let Status: String?
    let CountryOfBirth: String?
    let IdentityNumberCitizenship: String?
    let IdentityNumberDateOfBirth: String?
}
