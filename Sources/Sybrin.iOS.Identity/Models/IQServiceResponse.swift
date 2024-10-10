//
//  IQServicePesponse.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on.
//  Copyright © 2024 Sybrin Systems. All rights reserved.
//

import Foundation

 
struct IQServiceResponse: Codable {
    let correlationId: String?
    let results: [ResultItem]
}

struct ResultItem: Codable {
    let success: Bool
    let filename: String
    let dataProperties: [DataProperty]
}

struct DataProperty: Codable {
    let name: String
    let isValid: Bool
    let message: String
    let dataAttributes: DataAttributes
}

struct DataAttributes: Codable {
    let brisqueScore: Double?
    let blur: Double?
    let binaryVariance: Double?
}
