//
//  PhillippinesQCIdentificationCardBackPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Matthew Dickson on 2022/11/08.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//

import Foundation


import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import UIKit

final class PhilippinesQCIdentificationCardBackScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
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
    
    // MARK: Overrided Methods
    final override func PreProcessing(done: @escaping () -> Void) {
        guard let plan = Plan else { return }
        guard let previousModel = PreviousModel as? PhilippinesQCIdentificationCardModel else { return Fail(with: .InvalidModel, critical: true) }
        
        
        Model = previousModel
        //plan.mlKit?.BarcodeFormat = .code128
        NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
        
        DispatchQueue.main.async {
            CommonUI.updateLabelText(to: NotifyMessage.ScanBackCard.stringValue)
            done()
        }
    }
    
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        guard let model = Model as? PhilippinesQCIdentificationCardModel else { return Fail(with: .InvalidModel, critical: true) }
        guard !(PhaseAttemptLimit > 0 && PhaseAttempts > PhaseAttemptLimit) else {
            Fail(with: .Timeout)
            return
        }
      
    
        if model.BarcodeData == nil{
            LastFrame = buffer
            BarcodeScanning(from: buffer)
        } else {
            Constants.Backimage = LastFrame?.toUIImage(fixOrientation: true)
            
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        
        //Manual capture
        if Constants.isManualCapture == true {
            Constants.Backimage = LastFrame?.toUIImage(fixOrientation: true)
            
            Constants.isManualCapture = false
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        
        //Verfication
        if !PausePhaseAttempt && PhaseAttemptLimit > 0 {
            let currentTimeMs = Date().timeIntervalSince1970 * 1000
            guard (currentTimeMs - PreviousPhaseAttemptFrameTime) >= ThrottlePhaseAttemptByMilliseconds else { return }
            PreviousPhaseAttemptFrameTime = currentTimeMs

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                if self.PhaseAttempts < self.PhaseAttemptLimit {
                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeRemaining(topLine:(self.PreviousModel as? PhilippinesQCIdentificationCardModel)?.qcReferenceNumber, timeRemaining: self.PhaseAttemptLimit - self.PhaseAttempts).stringValue, animationColor: nil)
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
                controller.NotifyUser(WarningNotifyMessage, flashBorderColor: .orange, flashOverlayColor: nil)
                NotifyUserFrameTime = currentTimeMs
            }
        }
        
    }
    
    final override func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        guard let controller = Plan?.controller else { return }
        
        switch result {
            case .success(_):
//                guard let model = Model as? PhilippinesQCIdentificationCardModel else { return }
//                guard let previousModel = PreviousModel as? PhilippinesQCIdentificationCardModel else { return }
//                guard let frame = LastFrame else { return }
//                
//                //"Cropping and processing image".log(.Debug)
//            
//                model.DocumentImage = previousModel.DocumentImage
//                model.PortraitImage = previousModel.PortraitImage
//                model.CroppedDocumentImage = previousModel.CroppedDocumentImage
//
//                model.DocumentImagePath = previousModel.DocumentImagePath
//                model.PortraitImagePath = previousModel.PortraitImagePath
//                model.CroppedDocumentImagePath = previousModel.CroppedDocumentImagePath
//            
//                
//                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
//                
//                model.DocumentBackImage = image
//
//                if let barcode = LastBarcode {
//                    let barcodeRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? barcode.frame.RotateRight(containerWidth: image.size.width) : barcode.frame.RotateLeft(containerHeight: image.size.height)
//                    
//                    let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingBackLeftOffset, model.CroppingBackTopOffset, model.CroppingBackWidthOffset, model.CroppingBackHeightOffset, barcodeRect))
//
//                    model.CroppedDocumentBackImage = croppedDocumentImage
//                }
                
            DispatchQueue.main.async {
                
                let image = Constants.Backimage
                let imageView = UIView(frame: .zero) //UIImageView(image: image)
                imageView.backgroundColor = UIColor(hex: "#F5F5F5ff") //.lightGray
                
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleToFill
                
                controller.CameraPreview.addSubview(imageView)
                
                controller.CameraPreview.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: controller.CameraPreview.leadingAnchor),
                    imageView.topAnchor.constraint(equalTo: controller.CameraPreview.topAnchor),
                    imageView.trailingAnchor.constraint(equalTo: controller.CameraPreview.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: controller.CameraPreview.bottomAnchor),
                ])
                
                guard let scannedRect = RectangleDetectionHandler.detectRectangle(image: Constants.Backimage!) else { return }
                
                
                let imageProcessViewController = ImageProcessViewController(image: Constants.Backimage!.withHorizontallyFlippedOrientation(), rect: scannedRect) { (originalImage, croppedImage) in
                    
                    Constants.Backimage = croppedImage
                    
                    CommonUI.loadingAnim(to: imageView)
                    done()
                     
                }
                
                DispatchQueue.main.async {
                    self.Plan?.controller?.present(imageProcessViewController, animated: true)
                }
            }
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
                    guard let self = self else { return }
                    
                    controller.NotifyUser(NotifyMessage.DetectionFailed(for: (self.PreviousModel as? PhilippinesDriversLicenseModel)?.licenseNumber).stringValue, flashBorderColor: nil, flashOverlayColor: nil)
                    
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
        
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
        PreviousPhaseAttemptFrameTime = currentTimeMs
        
        PhaseAttempts = 0
    }
    
}
