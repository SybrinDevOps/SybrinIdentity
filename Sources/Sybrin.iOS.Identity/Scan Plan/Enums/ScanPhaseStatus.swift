//
//  ScanPhaseStatus.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

enum ScanPhaseStatus {
    case PhaseCreated
    case PhaseReady
    
    case PhasePreProcessing
    case PhaseProcessing
    case PhasePaused
    case PhasePostProcessing
    
    case PhaseCompleted
    case PhaseFailed
}
