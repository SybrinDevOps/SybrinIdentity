//
//  PhilippinesDriversLicenseBackScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import UIKit
////import MLKit

final class PhilippinesDriversLicenseBackScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    // **
    //private final var Barcode: Barcode?
    // **
    //private final var Face: Face?
    private final var FaceFrameCount: Int?
    private final var ModelFrameCount: Int?
    private final var LastFrame: CMSampleBuffer?
    private final var LastFrameImage: UIImage?
//    private final var Parser = PhilippinesIdentificationCardParser()
    private var Finished = false;
    
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
        if let previousIdentityNumber = (PreviousModel as? PhilippinesIdentificationCardModel)?.IdentityNumber {
            return (currentIdentityNumber.contains(previousIdentityNumber))
        } else {
            return false
        }
    }
    
    var phaseCount = 0
    
    private final let TextDetectedLimit = 3
    private final var TextDetectedCounter = 0
    
    private final let BarcodeDetectedLimit = 3
    private final var BarcodeDetectedCounter = 0
    
    // MARK: Overrided Methods
    final override func PreProcessing(done: @escaping () -> Void) {
        // **
        //guard let plan = Plan else { return }
        //5plan.mlKit?.BarcodeFormat = .PDF417
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
        
      if self.Finished/* && Face == nil */{
          
          if (LastFrameImage != nil) {
              Constants.Backimage = LastFrameImage?.fixOrientation(to: .up)
          } else {
              Constants.Backimage = LastFrame?.toUIImage(fixOrientation: true)
          }
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
          Constants.isManualCapture = false
        } else {
            LastFrame = buffer
            //TextRecognition(from: buffer)
            //BarcodeScanning(from: buffer)
            //TextRecognition(from: buffer)
        
            
            
            FaceDetection(from: buffer)
            TextRecognition(from: buffer)
            //BarcodeScanning(from: buffer)
            
        }
        
        if Constants.isManualCapture == true {
            if (LastFrameImage != nil) {
                Constants.Backimage = LastFrameImage
            } else {
                Constants.Backimage = LastFrame?.toUIImage(fixOrientation: true)
            }
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
                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeRemaining(topLine: (self.PreviousModel as? PhilippinesIdentificationCardModel)?.identityNumber, timeRemaining: self.PhaseAttemptLimit - self.PhaseAttempts).stringValue, animationColor: nil)
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
    
        phaseCount += 1
    }
    
    
    final override func ProcessImage(image: UIImage) {
        guard !(PhaseAttemptLimit > 0 && PhaseAttempts > PhaseAttemptLimit) else {
            Fail(with: .Timeout)
            return
        }
        
      if self.Finished/* && Face == nil*/{
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }else{
            LastFrameImage = image
            //TextRecognition(from: buffer)
            //BarcodeScanning(from: buffer)
            //TextRecognition(from: buffer)
            
            if Constants.isManualCapture == true {
                FaceDetectionManualImage(from: image)
                BarcodeScanningManualImage(from: image)
            } else {
                FaceDetectionManualImage(from: image)
                BarcodeScanningManualImage(from: image)
            }
            
        }
        
        
        if !PausePhaseAttempt && PhaseAttemptLimit > 0 {
            let currentTimeMs = Date().timeIntervalSince1970 * 1000
            guard (currentTimeMs - PreviousPhaseAttemptFrameTime) >= ThrottlePhaseAttemptByMilliseconds else { return }
            PreviousPhaseAttemptFrameTime = currentTimeMs
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if self.PhaseAttempts < self.PhaseAttemptLimit {
                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeRemaining(topLine: (self.PreviousModel as? PhilippinesIdentificationCardModel)?.identityNumber, timeRemaining: self.PhaseAttemptLimit - self.PhaseAttempts).stringValue, animationColor: nil)
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
    
        phaseCount += 1
    }
    
    final override func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        guard let controller = Plan?.controller else { return }
        
        switch result {
            case .success(_):
                var model: PhilippinesIdentificationCardModel?
            
                if Model == nil {
                    model = PhilippinesIdentificationCardModel()
                } else {
                    model = Model as? PhilippinesIdentificationCardModel
                }
            
                guard let model = model else { return }
            
            
                var previousModel: PhilippinesIdentificationCardModel?
            
                if PreviousModel == nil {
                    previousModel = PhilippinesIdentificationCardModel()
                } else {
                    previousModel = PreviousModel as? PhilippinesIdentificationCardModel
                }
            
                guard let previousModel = previousModel else { return }
            
            
                guard let frame = LastFrame else { return }
                
                model.DocumentImage = previousModel.DocumentImage
                model.PortraitImage = previousModel.PortraitImage
                model.CroppedDocumentImage = previousModel.CroppedDocumentImage
                
                model.DocumentImagePath = previousModel.DocumentImagePath
                model.PortraitImagePath = previousModel.PortraitImagePath
                model.CroppedDocumentImagePath = previousModel.CroppedDocumentImagePath
                
                //"Cropping and processing image".log(.Debug)
                
                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
                
                model.DocumentBackImage = image
                
            DispatchQueue.main.async {
                
                let _ = Constants.Backimage
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
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    controller.NotifyUser(NotifyMessage.DetectionFailed(for: (self.PreviousModel as? PhilippinesIdentificationCardModel)?.IdentityNumber).stringValue, flashBorderColor: nil, flashOverlayColor: nil)
                    
                    
                    
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
        
//        Face = nil
        FaceFrameCount = nil
        ModelFrameCount = nil
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
        PreviousPhaseAttemptFrameTime = currentTimeMs
        
        PhaseAttempts = 0
    }
    
}
