//
//  PhilSeafarerIdentificationRecordBookResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation
struct PhilHealthInsuranceResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedHealthInsuranceData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedHealthInsuranceData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedHealthInsuranceData : Codable {
    
    let PhilHealthNumber: String?
    let FullName: String?
    let DateOfBirth: String?
    let Sex: String?
    let Address: String?
    
    let WordConfidenceResults: String?
    //let FrontImageSecurityCheckSuccess: String?
    let FaceDetection: [FaceDetection]?
}

