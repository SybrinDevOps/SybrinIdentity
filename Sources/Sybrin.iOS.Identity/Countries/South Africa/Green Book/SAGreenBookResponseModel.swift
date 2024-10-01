//
//  SAIDGreenBookResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/10/15.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct SAGreenBookResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedSAGreenBookData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedSAGreenBookData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedSAGreenBookData: Codable {
    let Surname: String?
    let FirstNames: String?
    let IdentityNumber: String?
    let IdentityNumberADigit: Int?
    let IdentityNumberCheckDigit: Int?
    let IdentityNumberSex: String?
    let WordConfidenceResults: String?
    let CountryOfBirth: String?
    let IdentityNumberCitizenship: String?
    let IdentityNumberDateOfBirth: String?
    let DateOfBirth: String?
    let BookType: String?
}
