//
//  PhilippinesSeafarerIdentificationDocumentBackScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import UIKit

final class PhilippinesSeafarerIdentificationDocumentBackScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    private final var FaceFrameCount: Int?
    private final var ModelFrameCount: Int?
    private final var LastFrame: CMSampleBuffer?
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // Phase Variables
    private final var PreviousPhaseAttemptFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let ThrottlePhaseAttemptByMilliseconds: Double = 1000
    private final var PhaseAttempts = 0
    private final let PhaseAttemptLimit = 20
    private final var PausePhaseAttempt = !(SybrinIdentity.shared.configuration?.enableMultiPhaseVerification ?? SybrinIdentityConfiguration.EnableMultiPhaseVerification)
    
    // Validation
    private final let ValidateFrontAndBack: Bool = SybrinIdentity.shared.configuration?.enableMultiPhaseVerification ?? SybrinIdentityConfiguration.EnableMultiPhaseVerification
    
    // MARK: Private Methods
    private final func ValidateIdentityNumber(for currentIdentityNumber: String) -> Bool {
        if let previousIdentityNumber = (PreviousModel as? PhilippinesSeafarerIdentificationDocumentModel)?.IdentityNumber {
            return (currentIdentityNumber.contains(previousIdentityNumber))
        } else {
            return false
        }
    }
    
    // MARK: Overrided Methods
    final override func PreProcessing(done: @escaping () -> Void) {
        // **
        guard let _ = Plan else { return }
//        plan.mlKit?.BarcodeFormat = .PDF417
        // **
        
        NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
        
        DispatchQueue.main.async {
            CommonUI.updateLabelText(to: NotifyMessage.ScanBackCard.stringValue)
            done()
        }
    }
    
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        guard !(PhaseAttemptLimit > 0 && PhaseAttempts > PhaseAttemptLimit) else {
            Fail(with: .Timeout)
            return
        }
        
        if Model == nil || !(FaceFrameCount == ModelFrameCount) {
            if  Model != nil && ((ModelFrameCount ?? 0) < FrameCounter) {
                Model = nil
                ModelFrameCount = nil
            }
            if Model == nil && ((FaceFrameCount ?? 0) < FrameCounter) {
                
                FaceFrameCount = nil
            }
            
            LastFrame = buffer
            if FaceFrameCount == nil {
                FaceDetection(from: buffer)
            }
            if Model == nil && ModelFrameCount == nil {
                TextRecognition(from: buffer)
            }
        } else if FaceFrameCount == ModelFrameCount {
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        if Constants.isManualCapture == true {
            Constants.isManualCapture = false
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        if !PausePhaseAttempt && PhaseAttemptLimit > 0 {
            let currentTimeMs = Date().timeIntervalSince1970 * 1000
            guard (currentTimeMs - PreviousPhaseAttemptFrameTime) >= ThrottlePhaseAttemptByMilliseconds else { return }
            PreviousPhaseAttemptFrameTime = currentTimeMs
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if self.PhaseAttempts < self.PhaseAttemptLimit {
                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeRemaining(topLine: (self.PreviousModel as? PhilippinesSeafarerIdentificationDocumentModel)?.identityNumber, timeRemaining: self.PhaseAttemptLimit - self.PhaseAttempts).stringValue, animationColor: nil)
                } else {
                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeExpired.stringValue, animationColor: .red)
                }
                
                self.PhaseAttempts += 1
            }
        }
        
        // Notifying user if scanning is taking too long
        if !(SybrinIdentity.shared.configuration?.enableHelpMessages ?? SybrinIdentityConfiguration.EnableHelpMessages) {
            let currentTimeMs = Date().timeIntervalSince1970 * 1000
            if (currentTimeMs - NotifyUserFrameTime) >= DelayNotifyUserEveryMilliseconds {
                guard let controller = Plan?.controller else { return }
                
                controller.ManualCaptureButton.isHidden = false
                controller.buttonBg.isHidden = false
                controller.NotifyUser(WarningNotifyMessage, flashBorderColor: .orange, flashOverlayColor: nil)
                NotifyUserFrameTime = currentTimeMs
            }
        }

    }
    
    final override func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        guard let controller = Plan?.controller else { return }
        
        switch result {
            case .success(_):
                guard let model = Model as? PhilippinesSeafarerIdentificationDocumentModel else { return }
                guard let previousModel = PreviousModel as? PhilippinesSeafarerIdentificationDocumentModel else { return }
                guard let frame = LastFrame else { return }
                
                model.DocumentImage = previousModel.DocumentImage
                model.PortraitImage = previousModel.PortraitImage
                model.CroppedDocumentImage = previousModel.CroppedDocumentImage
                
                model.DocumentImagePath = previousModel.DocumentImagePath
                model.PortraitImagePath = previousModel.PortraitImagePath
                model.CroppedDocumentImagePath = previousModel.CroppedDocumentImagePath
                
                //"Cropping and processing image".log(.Debug)
                
                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
            
//                if let face = Face {
//                    let faceRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? face.frame.RotateRight(containerWidth: image.size.width) : face.frame.RotateLeft(containerHeight: image.size.height)
//                    
//                    let portraitImage = image.CropImage(faceRect, padding: 25)
//                    let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingBackLeftOffset, model.CroppingBackTopOffset, model.CroppingBackWidthOffset, model.CroppingBackHeightOffset, faceRect))
//                    
//                    model.PortraitBackImage = portraitImage
//                    model.CroppedDocumentBackImage = croppedDocumentImage
//                }
            
                model.DocumentBackImage = image
            
            DispatchQueue.main.async {
                CommonUI.updateLabelText(to: NotifyMessage.NiceYouGotIt.stringValue)
                
                CommonUI.flashBorders(withColor: .green)
                
                IdentityUI.AnimateRotateCard(controller.CameraPreview, completion: { _ in
                    done()
                })
            
            }
                
                //done()
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
                    guard let self = self else { return }
                    
                    controller.NotifyUser(NotifyMessage.DetectionFailed(for: (self.PreviousModel as? PhilippinesSeafarerIdentificationDocumentModel)?.IdentityNumber).stringValue, flashBorderColor: nil, flashOverlayColor: nil)
                    
                    CommonUI.updateLabelText(to: NotifyMessage.ScanFrontCard.stringValue)
                    CommonUI.updateSubLabelText(to: NotifyMessage.Empty.stringValue, animationColor: nil)
                    
                    IdentityUI.AnimateRotateCard(controller.CameraPreview, forward: false, completion: { _ in
                        done()
                    })
                    
                }
        }
        
    }
    
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        FaceFrameCount = nil
        ModelFrameCount = nil
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
        PreviousPhaseAttemptFrameTime = currentTimeMs
        
        PhaseAttempts = 0
    }
    
}
