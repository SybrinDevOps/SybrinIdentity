//
//  PhilIDCardResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/17.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct PhilIDCardResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedData: String?
    let FrontImage: String?
    let BackImage: String?
    
//    enum CodingKeys: String, CodingKey {
//        case CorrelationID = "CorrelationID"
//        case ExtractedData = "ExtractedData"
//    }
}

struct ExtractedData : Codable {
    let IdentityNumber: String?
    let LastName: String?
    let GivenNames: String?
    let MiddleName: String?
    let Sex: String?
    let DateOfBirth: String?
    let DateOfIssue: String?
    let Address: String?
    let MaritalStatus: String?
    let BloodType: String?
    let PlaceOfBirth: String?
    let FrontImageSecurityCheckSuccess: Bool?
    let WordConfidenceResults: String?
    let FaceDetection: [FaceDetection]?
}


struct FaceDetection: Codable {
    let FaceID: String?
    let FaceImage: String?
}

struct WordConfidenceResults {
    let IDNumber: Double?
    let LastName: Double?
    let GivenNames: Double?
    let MiddleName: Double?
    let Sex: Double?
    let DateOfBirth: Double?
    let DateOfIssue: Double?
    let Address: Double?
    let MaritalStatus: Double?
    let PlaceOfBirth: Double?
}


