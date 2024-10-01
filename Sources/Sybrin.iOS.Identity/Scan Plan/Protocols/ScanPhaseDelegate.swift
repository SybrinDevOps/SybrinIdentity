//
//  ScanPhaseDelegate.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

protocol ScanPhaseDelegate: AnyObject {
    func PhaseStartedProcessing()
    
    func PhasePausedProcessing()
    func PhaseResumedProcessing()
    
    func PhaseCompleted()
    func PhaseFailed(with reason: ScanFailReason, critical: Bool)
}

extension ScanPhaseDelegate {
    func PhaseStartedProcessing() { }
    
    func PhasePausedProcessing() { }
    func PhaseResumedProcessing() { }
    
    func PhaseCompleted() { }
    func PhaseFailed(with reason: ScanFailReason, critical: Bool) { }
}
