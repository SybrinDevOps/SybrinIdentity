//
//  PhilUnifiedMPIDResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation
struct PhilUnifiedMPIDResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedUnifiedMPIDData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedUnifiedMPIDData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedUnifiedMPIDData : Codable {
    let CommonReferenceNumber: String?
    let GivenName: String?
    let Surname: String?
    let Sex: String?
    let WordConfidenceResults: String?
    let Address: String?
    let DateOfBirth: String?
    
    let FrontImageSecurityCheckSuccess: Bool?
    let FaceDetection: [FaceDetection]?
}
