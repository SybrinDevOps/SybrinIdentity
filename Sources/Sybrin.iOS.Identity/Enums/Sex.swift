//
//  Sex.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

@objc public enum Sex: Int, Encodable {
    case Male
    case Female
    case Undetermined
    
    public var stringValue: String {
        switch self {
            case .Male: return "Male"
            case .Female: return "Female"
            case .Undetermined: return "Undetermined"
        }
    }
}
