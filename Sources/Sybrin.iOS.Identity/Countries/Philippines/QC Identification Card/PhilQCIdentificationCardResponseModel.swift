//
//  PhilQCIdentificationCardResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/23.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct PhilQCIdentificationCardResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedQCIdentificationCardResponseData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedQCIdentificationCardResponseData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedQCIdentificationCardResponseData : Codable {
    let QCReferenceNumber: String?
    let FullName: String?
    let Sex: String?
    let DateOfBirth: String?
    let DateOfIssue: String?
    let CivilStatus: String?
    let BloodType: String?
    let Nationality: String?
    let CitizenType: String?
    let ValidUntil: String?
    let DisabilityType: String?
    let Address: String?
    let WordConfidenceResults: String?
    
    let FrontImageSecurityCheckSuccess: Bool?
    let FaceDetection: [FaceDetection]?
}

