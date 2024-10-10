//
//  PhilSocialSecurityResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation
struct PhilSocialSecurityResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedSocialSecurityData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedSocialSecurityData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedSocialSecurityData : Codable {
    
    let SocialSecurityNumber: String?
    let FullName: String?
    let DateOfBirth: String?
    let WordConfidenceResults: String?
    let FaceDetection: [FaceDetection]?
}
