//
//  ScanPlanDelegate.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

protocol ScanPlanDelegate: AnyObject {
    func PlanStarted()
    
    func PlanChangingPhases<T>(from phase: ScanPhase<T>)
    func PlanChangedPhases<T>(to phase: ScanPhase<T>)
    
    func PlanPaused<T>(at phase: ScanPhase<T>)
    func PlanResumed<T>(at phase: ScanPhase<T>)
    
    func PlanCompleted<T>(with model: T?)
    func PlanFailed(with reason: ScanFailReason)
    func PlanCanceled()
}

extension ScanPlanDelegate {
    func PlanStarted() { }
    
    func PlanChangingPhases<T>(from phase: ScanPhase<T>) { }
    func PlanChangedPhases<T>(to phase: ScanPhase<T>) { }
    
    func PlanPaused<T>(at phase: ScanPhase<T>) { }
    func PlanResumed<T>(at phase: ScanPhase<T>) { }
    
    func PlanCompleted<T>(with model: T?) { }
    func PlanFailed(with reason: ScanFailReason) { }
    func PlanCanceled() { }
}
