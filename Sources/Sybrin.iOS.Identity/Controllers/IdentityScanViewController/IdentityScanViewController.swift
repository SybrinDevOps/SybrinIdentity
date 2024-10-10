//
//  IdentityScanViewController.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common
import AVFoundation
import MLKitFaceDetection ////import MLKit
import Foundation

final class IdentityScanViewController: UIViewController {
    
    // MARK: Private Properties
    private final var Orientations = UIInterfaceOrientationMask.portrait
    
    // MARK: Internal Properties
    final var Plan: ScanPlan<DocumentModel>!
    final weak var Delegate: HandleIdentityResponse?
    
    // MARK: IBOutlets
    @IBOutlet final weak var CameraPreview: UIView!
    @IBOutlet final weak var HeadingBrandingLabel: UILabel!
    @IBOutlet final weak var SubtitleBrandingLabel: UILabel!
    
    @IBOutlet final weak var ManualCaptureButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet final weak var buttonBg: UIView!
    
    
    var count = 1
        
    // MARK: UIViewController Overrides
    final override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self.Orientations }
        set { self.Orientations = newValue }
    }
    
    //
    var presenter: IdentityScanPresenter?
    
    final override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter = IdentityScanPresenter(view: self)
        presenter?.perform(.viewWillAppear)
    }
    
    final override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBg.layer.cornerRadius = 65 / 2
        ManualCaptureButton.setTitle("", for: .normal)
        
        DispatchQueue.main.async {
            self.ManualCaptureButton.isHidden = false
            self.buttonBg.isHidden = false
        }
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    final override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    final override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: User Interaction
    final func DismissUI(with tag: Int, completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: true, completion: completion)
        }
    }
    
    final func NotifyUser(_ message: String?, flashBorderColor: UIColor?, flashOverlayColor: UIColor?) {
        
//        DispatchQueue.main.async {
//            self.ManualCaptureButton.isHidden = false
//            self.buttonBg.isHidden = false
//        }
//
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let flashBorderColor = flashBorderColor {
                CommonUI.flashBorders(withColor: flashBorderColor)
            }
            if let flashOverlayColor = flashOverlayColor {
                CommonUI.flashOverlay(withColor: flashOverlayColor)
            }
            if let message = message, SybrinIdentity.shared.configuration?.displayToastMessages ?? SybrinIdentityConfiguration.DisplayToastMessages {
                //ToastHandler.show(message: message, view: self.view)
            }
        }
    }
    
    @IBAction func capture(_ sender: Any) {
        //ManuallyCaptureImage()
        Constants.isManualCapture = true
//        buttonBg.isHidden = true
//        ManualCaptureButton.isHidden = true
    }
}

// MARK: - Extensions

// MARK: Scan View Controller
extension IdentityScanViewController: ScanViewController {
    
    
    func ManuallyCaptureImage() {
        Plan.camera?.cameraTakePicture()
        
        Constants.isManualCapture = true

        
    }
    
    func PlanCompleted<DocumentModel>(with model: DocumentModel?) {
        Delegate?.handleResponse(model)
    }
    
    func PlanFailed(with reason: ScanFailReason) {
        Delegate?.handleFailure(reason: reason.rawValue)
    }
    
    func PlanCanceled() {
        Delegate?.handleCancel()
    }
    
    
}

extension IdentityScanViewController: IIdentityScanView {
    func perform(_ update: IdentityScanContract.Update) {
        switch update {
        case .viewWillAppearUpdate:
            Plan.Start()
        case .viewDidLoadUpdate:
            break
        }
    }
}
