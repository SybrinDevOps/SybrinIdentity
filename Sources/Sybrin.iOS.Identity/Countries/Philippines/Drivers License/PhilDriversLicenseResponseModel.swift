//
//  PhilDriversLicenseResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

//
//  PhilPassportResponseModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/03/22.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation

struct PhilDriversLicenseResponseModel: Codable {
    let CorrelationID: String?
    let ExtractedDriversLicenseData: String?
    let FrontImage: String?
    let BackImage: String?
    
    enum CodingKeys: String, CodingKey {
        case CorrelationID = "CorrelationID"
        case ExtractedDriversLicenseData = "ExtractedData"
        case FrontImage = "FrontImage"
        case BackImage = "BackImage"
    }
}

struct ExtractedDriversLicenseData : Codable {
    let Names: String?
    let LastName: String?
    let Nationality: String?
    let Address: String?
    
    let Sex: String?
    let DateOfBirth: String?
    let Weight: String?
    let Height: String?
    let Addrees: String?
    let LicenseNumber: String?
    let SerialNumber: String?
    let ExpirationDate: String?
    let AgencyCode: String?
//    let BloodType: String?
//    let EyeColor: String
//    let Restrictions: String?
//    let Conditions: String?
    let WordConfidenceResults: String?
    let FrontImageSecurityCheckSuccess: Bool?
    let FaceDetection: [FaceDetection]?
}
