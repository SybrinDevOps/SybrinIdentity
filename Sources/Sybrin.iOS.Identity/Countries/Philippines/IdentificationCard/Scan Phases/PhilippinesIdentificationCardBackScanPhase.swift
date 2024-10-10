////
////  PhilippinesIdentificationCardbackScanPhase.swift
////  Sybrin.iOS.Identity
////
////  Created by Default on 2022/05/04.
////  Copyright © 2022 Sybrin Systems. All rights reserved.
////
//
//import Sybrin_iOS_Common
//import AVFoundation
////import MLKit
//
//class PhilippinesIdentificationCardBackScanPhase: ScanPhase<DocumentModel>  {
//    
//    // MARK: Private Properties
//    private final var LastBarcode: Barcode?
//    private final var LastFrame: CMSampleBuffer?
//    private final var Parser = PhilippinesIdentificationCardParser()
//    
//    // Notify User
//    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
//    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
//    
//    // Phase Variables
//    private final var PreviousPhaseAttemptFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private final let ThrottlePhaseAttemptByMilliseconds: Double = 1000
//    private final var PhaseAttempts = 0
//    private final let PhaseAttemptLimit = 20
//    private final var PausePhaseAttempt = !(SybrinIdentity.shared.configuration?.enableMultiPhaseVerification ?? SybrinIdentityConfiguration.EnableMultiPhaseVerification)
//    private var trys = 0
//    
//    // MARK: Overrided Methods
//    final override func PreProcessing(done: @escaping () -> Void) {
//        guard let plan = Plan else { return }
//        guard let previousModel = PreviousModel as? PhilippinesIdentificationCardModel else { return Fail(with: .InvalidModel, critical: true) }
//        
//        Model = previousModel
//        plan.mlKit?.BarcodeFormat = .PDF417
//        NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
//        
//        DispatchQueue.main.async {
//            CommonUI.updateLabelText(to: NotifyMessage.ScanBackCard.stringValue)
//            done()
//        }
//    }
//    
//    final override func ProcessFrame(buffer: CMSampleBuffer) {
//        if Model == nil {
//            LastFrame = buffer
//            if Model == nil {
//                TextRecognition(from: buffer)
//            }
//            
////            LastFrame = buffer
////            if model.BarcodeData == nil {
////                BarcodeScanning(from: buffer)
////            }
////            if model.CommonReferenceNumber == nil {
////                TextRecognition(from: buffer)
////            }
//        } else {
//            
//            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
//            Complete()
//        }
//        
//        
////        if !PausePhaseAttempt && PhaseAttemptLimit > 0 {
////            let currentTimeMs = Date().timeIntervalSince1970 * 1000
////            guard (currentTimeMs - PreviousPhaseAttemptFrameTime) >= ThrottlePhaseAttemptByMilliseconds else { return }
////            PreviousPhaseAttemptFrameTime = currentTimeMs
////            
////            DispatchQueue.main.async { [weak self] in
////                guard let self = self else { return }
////                
////                if self.PhaseAttempts < self.PhaseAttemptLimit {
////                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeRemaining(topLine: "Identity card", timeRemaining: self.PhaseAttemptLimit - self.PhaseAttempts).stringValue, animationColor: nil)
////                } else {
////                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeExpired.stringValue, animationColor: .red)
////                }
////                
////                self.PhaseAttempts += 1
////            }
////        }
//        
//        // Notifying user if scanning is taking too long
//        if !(SybrinIdentity.shared.configuration?.enableHelpMessages ?? SybrinIdentityConfiguration.EnableHelpMessages) {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            if (currentTimeMs - NotifyUserFrameTime) >= DelayNotifyUserEveryMilliseconds {
//                guard let controller = Plan?.controller else { return }
//                
//                controller.NotifyUser(WarningNotifyMessage, flashBorderColor: .orange, flashOverlayColor: nil)
//                NotifyUserFrameTime = currentTimeMs
//            }
//        }
//        
//    }
//    
//    final override func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
//        guard let controller = Plan?.controller else { return }
//        
//        switch result {
//            case .success(_):
//                guard let model = Model as? PhilippinesIdentificationCardModel else { return }
//                guard let frame = LastFrame else { return }
//                
//                //"Cropping and processing image".log(.Debug)
//                
//                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
//            
//                model.DocumentImage = image
//
////                if let barcode = LastBarcode {
////                    let barcodeRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? barcode.frame.RotateRight(containerWidth: image.size.width) : barcode.frame.RotateLeft(containerHeight: image.size.height)
////
////                    let barcodeImage = image.CropImage(barcodeRect, padding: 25)
////                    let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingBackLeftOffset, model.CroppingBackTopOffset, model.CroppingBackWidthOffset, model.CroppingBackHeightOffset, barcodeRect))
////
////                    model.BarcodeImage = barcodeImage
////                    model.CroppedDocumentBackImage = croppedDocumentImage
////                }
//                
//                done()
//            case .failure(_):
//                done()
////                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
////                    guard let self = self else { return }
////
//////                    controller.NotifyUser(NotifyMessage.DetectionFailed(for: (self.PreviousModel as? PhilippinesIdentificationCardModel)?.commonReferenceNumber).stringValue, flashBorderColor: nil, flashOverlayColor: nil)
////
////                    CommonUI.updateLabelText(to: NotifyMessage.ScanFrontCard.stringValue)
////                    CommonUI.updateSubLabelText(to: NotifyMessage.Empty.stringValue, animationColor: nil)
////
//////                    IdentityUI.AnimateRotateCard(controller.CameraPreview, forward: false, completion: { _ in
//////                        done()
//////                    })
////
////                }
//        }
//        
//    }
//    
//    final override func ProcessTextRecognition(text: Text) {
//        guard text.text.count > 0 else { return }
//
//        switch SybrinIdentityConfiguration.EnablePartialScanning {
//            case false:
//                Parser.ParseBackText(from: text) { [weak self] (model) in
//                    guard let self = self else { return }
//
//                    "Found Serial Number".log(.Verbose)
////                    (self.Model as? PhilippinesIdentificationCardModel)?.CommonReferenceNumber = model.CommonReferenceNumber
//                    self.Model = model
//                }
//            case true:
//                Parser.ParseBackTextPartialScan(from: text) { [weak self] (model) in
//                    guard let self = self else { return }
//
//                    "Found Number".log(.Verbose)
////                    (self.Model as? PhilippinesIdentificationCardModel)?.CommonReferenceNumber = model.CommonReferenceNumber
//                    self.Model = model
//                }
//        }
//        
//    }
//    
//    final override func ProcessBarcodeScanning(barcodes: [Barcode]) {
////        for barcode in barcodes {
////            Parser.ParseBackBarcode(from: barcode) { [weak self] (model) in
////                guard let self = self else { return }
////
////                "Found Barcode".log(.Verbose)
////                (self.Model as? PhilippinesDriversLicenseModel)?.BarcodeData = model.BarcodeData
////                self.LastBarcode = barcode
////            }
////        }
//    }
//    
//    final override func ResetData() {
//        let currentTimeMs = Date().timeIntervalSince1970 * 1000
//        
//        LastFrame = nil
//        LastBarcode = nil
//        
//        NotifyUserFrameTime = currentTimeMs
//        PreviousPhaseAttemptFrameTime = currentTimeMs
//        
//        PhaseAttempts = 0
//        
//
//    }
//
//}
