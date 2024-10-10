//
//  ScanFailReason.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

enum ScanFailReason: String, Error {
    case CameraPermissions = "Camera permissions denied"
    case Timeout = "Timeout"
    case InvalidModel = "Model was invalid"
    case ValidationFailed = "Validation failed"
    case NoPhases = "No phases"
    case NoInternet = "No internet"
    
    case Unspecified = "Unspecified"
}
