//
//  IdentityNetworkError.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/10/20.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

enum IdentityNetworkError: Error {
    case NetworkError(error: NetworkError)
    
    case Error(message: String, details: String?)
    
    var message: String {
        switch self {
            case .NetworkError(let error): return "NetworkError: \(error)"
                
            case .Error(let message, let details): return "Error Message: \(message)\((details != nil) ? ", Error Details: \(details!)" : "")"
        }
    }
    
}

