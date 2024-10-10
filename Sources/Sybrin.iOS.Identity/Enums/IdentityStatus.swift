//
//  IdentityStatus.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/31.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

enum IdentityStatus: Int {
    case NotInitialized
    
    case InitializationFailed
    case ReadyToScan
    
    case ScanningInProgress
}
