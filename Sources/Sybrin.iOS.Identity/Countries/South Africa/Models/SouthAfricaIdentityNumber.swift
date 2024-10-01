//
//  SouthAfricaIdentityNumber.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Foundation

struct SouthAfricaIdentityNumber {
    
    // MARK: Internal Properties
    var IdentityNumber: String?
    var DateOfBirth: Date?
    var Sex: Sex?
    var Citizenship: CitizenshipType?
    var ADigit: Int?
    var CheckDigit: Int?
}
