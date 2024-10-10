//
//  CitizenshipType.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/24.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

@objc public enum CitizenshipType: Int, Encodable {
    case Citizen
    case PermanentResident
    case Unknown
    
    public var stringValue: String {
        switch self {
            case .Citizen: return "Citizen"
            case .PermanentResident: return "Permanent Resident"
            case .Unknown: return "Unknown"
        }
    }
    
}
