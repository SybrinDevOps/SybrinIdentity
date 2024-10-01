//
//  PhilPostalIDResponse.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/23.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation
struct PhilPostalIDResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedPostalIDResponseData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedPostalIDResponseData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedPostalIDResponseData : Codable {
    let PostalReferenceNumber: String?
    let FullName: String?
    let Address: String?
    let Nationality: String?
    let IssuingPostOffice: String?
    let DateOfBirth: String?
    let ValidUntil: String?
    let CardType: String?
    let FrontImageSecurityCheckSuccess: Bool?
    let WordConfidenceResults: String?
    let FaceDetection: [FaceDetection]?
}


