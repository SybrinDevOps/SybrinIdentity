//
//  GreenBookType.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/24.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

@objc public enum GreenBookType: Int, Encodable {
    case Bilingual
    case English
    case Unspecified
    
    public var stringValue: String {
        switch self {
            case .Bilingual: return "Bilingual"
            case .English: return "English"
            case .Unspecified: return "Unspecified"
        }
    }
}
