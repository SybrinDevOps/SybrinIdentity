//
//  ScanViewController.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

protocol ScanViewController: UIViewController, ScanPlanDelegate {
    var CameraPreview: UIView! {get}
    var HeadingBrandingLabel: UILabel! {get}
    var SubtitleBrandingLabel: UILabel! {get}
    var ManualCaptureButton: UIButton! {get}
    var buttonBg: UIView! {get}
    
    var Plan: ScanPlan<DocumentModel>! {get}
    var Delegate: HandleIdentityResponse? {get}
    
    func DismissUI(with tag: Int, completion: @escaping () -> Void)
    func NotifyUser(_ message: String?, flashBorderColor: UIColor?, flashOverlayColor: UIColor?)
    func ManuallyCaptureImage()
}
