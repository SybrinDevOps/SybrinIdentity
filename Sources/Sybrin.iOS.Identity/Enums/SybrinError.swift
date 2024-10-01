//
//  SybrinError.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/24.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

enum SybrinError: Error {
    case ConfigurationNotSet
    case CountryNotSupported
    
    case Licensing(error: LicenseError)
    case SybrinStoryboardNotFound
    case SybrinViewControllerNotFound
    
    case CameraAccessDenied
    case ScanInProgress
    case InternalError
    
    var message: String {
        switch self {
            case .ConfigurationNotSet: return "The configuration variable is not set"
            case .CountryNotSupported: return "The selected country is not supported. Please select a different country"
                
            case .Licensing(let error): return error.message
            case .SybrinStoryboardNotFound: return "Failed to find the Sybrin Storyboard. Please contact Sybrin Systems to rectify"
            case .SybrinViewControllerNotFound: return "Failed to find the Sybrin View Controller. Please contact Sybrin Systems to rectify"
                
            case .CameraAccessDenied: return "Camera access has been denied. Camera permission is required to scan"
            case .ScanInProgress: return "Scanning is already in progress. Please wait for the existing scan to complete"
            case .InternalError: return "An internal error occured and prevented the intended action from completing. Please contact Sybrin Systems to rectify"
        }
    }
    
}
