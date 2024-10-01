//
//  PhilProfessionalRegulationCommissionCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct PhilProfessionalRegulationCommissionCardResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedProfessionalRegulationCommissionCardData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedProfessionalRegulationCommissionCardData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedProfessionalRegulationCommissionCardData : Codable {
    
    let FirstName: String?
    let LastName: String?
    let MiddleInitialName: String?
    let RegistrationNumber: String?
    let ValidUntil: String?
    let Profession: String?
    let DateOfBirth: String?
    let DateOfIssued: String?
    let WordConfidenceResults: String?
    let Address: String?
    let RegistrationDate: String?
    
    let FrontImageSecurityCheckSuccess: Bool?
    let FaceDetection: [FaceDetection]?
}
