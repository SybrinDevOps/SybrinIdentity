//
//  PhilSeafarerIdentificationRecordBookResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation
struct PhilSeafarerIdentificationRecordBookResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedSeafarerIdentificationRecordData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedSeafarerIdentificationRecordData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedSeafarerIdentificationRecordData : Codable {
    
    let FullName: String?
    let DateOfBirth: String?
    let Height: String?
    let Weight: String?
    let EyeColor: String?
    let HairColor: String?
    let DistinguishingMarks: String?
    let Sex: String?
    let DocumentNumber: String?
    let DateOfIssue: String?
    let PlaceOfIssue: String?
    let ValidUntil: String?
    let WordConfidenceResults: String?
//    let FrontImageSecurityCheckSuccess: String?
    let FaceDetection: [FaceDetection]?
}

