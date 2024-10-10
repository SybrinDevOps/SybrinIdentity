//
//  PhilIntegratedBarIDResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct PhilIntegratedBarIDResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedIntegratedBarIDData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedIntegratedBarIDData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedIntegratedBarIDData : Codable {
    let FullName: String?
    let IntegratedBarPhilippinesChapter: String?
    let RollOfAttorneysNumber: String?
    
    let WordConfidenceResults: String?
    let FrontImageSecurityCheckSuccess: Bool?
    let FaceDetection: [FaceDetection]?
}
