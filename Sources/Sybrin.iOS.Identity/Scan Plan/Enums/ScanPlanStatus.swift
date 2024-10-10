//
//  ScanPlanStatus.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

enum ScanPlanStatus {
    case PlanCreated
    case PlanReady
    
    case PlanChangingPhases
    case PlanProcessing
    case PlanPaused
    
    case PlanCompleted
    case PlanFailed
}
