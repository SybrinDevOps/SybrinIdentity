////
////  SouthAfricaStudyPermitScanPhase.swift
////  Sybrin.iOS.Identity
////
////  Created by Armand Riley on 2021/09/03.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
//import Sybrin_iOS_Common
//import AVFoundation
////import MLKit
//
//final class SouthAfricaStudyPermitScanPhase: ScanPhase<DocumentModel> {
//    
//    // MARK: Private Properties
//    private final var Barcode: Barcode?
//    private final var LastFrame: CMSampleBuffer?
//    private final var Parser = SouthAfricaStudyPermitParser()
//    
//    // Notify User
//    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
//    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
//    
//    // MARK: Overrided Methods
//    final override func PreProcessing(done: @escaping () -> Void) {
//        guard let plan = Plan else { return }
//        
//        plan.mlKit?.BarcodeFormat = .all
//        done()
//    }
//    
//    final override func ProcessFrame(buffer: CMSampleBuffer) {
//        if Barcode == nil || Model == nil {
//            LastFrame = buffer
//            BarcodeScanning(from: buffer)
//            if Model == nil {
//                TextRecognition(from: buffer)
//            }
//        } else {
//            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
//            Complete()
//        }
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
//        
//        switch result {
//            case .success(_):
//                guard let model = Model as? SouthAfricaStudyPermitModel else { return }
//                guard let frame = LastFrame else { return }
//                guard let barcode = Barcode else { return }
//                
//                model.BarcodeData = Barcode?.displayValue
//                
//                //"Cropping and processing image".log(.Debug)
//                
//                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
//                
//                let faceRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? barcode.frame.RotateRight(containerWidth: image.size.width) : barcode.frame.RotateLeft(containerHeight: image.size.height)
//                
//                let portraitImage = image.CropImage(faceRect, padding: 25)
//                let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingLeftOffset, model.CroppingTopOffset, model.CroppingWidthOffset, model.CroppingHeightOffset, faceRect))
//                
//                model.DocumentImage = image
//                model.PortraitImage = portraitImage
//                model.CroppedDocumentImage = croppedDocumentImage
//                
//                done()
//            case .failure(_):
//                done()
//        }
//        
//    }
//    
//    override func ProcessBarcodeScanning(barcodes: [Barcode]) {
//        if barcodes.count >= 1 {
//            Barcode = barcodes.max(by: { a, b in a.frame.width < b.frame.width })
//            "Found Barcode".log(.Verbose)
//        }
//    }
//    
//    final override func ProcessTextRecognition(text: Text) {
//        guard text.text.count > 0 else { return }
//        
//        Parser.Parse(from: text) { [weak self] (model) in
//            guard let self = self else { return }
//            
//            "Found Model".log(.Verbose)
//            self.Model = model
//        }
//    }
//    
//    final override func ResetData() {
//        let currentTimeMs = Date().timeIntervalSince1970 * 1000
//        
//        Barcode = nil
//        LastFrame = nil
//        
//        NotifyUserFrameTime = currentTimeMs
//    }
//    
//}
