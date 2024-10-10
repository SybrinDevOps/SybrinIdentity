//
//  PhilippinesQCIdentificationCardFrontPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Matthew Dickson on 2022/11/08.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//

import Foundation


import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
////import MLKit

final class PhilippinesQCIdentificationCardFrontScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    private final var LastFrame: CMSampleBuffer?
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // MARK: Overrided Methods
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        if Model == nil {
            LastFrame = buffer
//            FaceDetection(from: buffer)
            if Model == nil {
//                TextRecognition(from: buffer)
            }
            
        } else {
            Constants.frontImage = LastFrame?.toUIImage(fixOrientation: true)
            
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        if Constants.isManualCapture == true {
            Constants.frontImage = LastFrame?.toUIImage(fixOrientation: true)
            
            Constants.isManualCapture = false
            Model = PhilippinesQCIdentificationCardModel();
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }

        DispatchQueue.main.async {
            self.showPopup(view: self.Plan!.controller!.CameraPreview!)
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
//                guard let frame = LastFrame else { return }
//                
//                
//                //"Cropping and processing image".log(.Debug)
//                
//                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
//            
//                if let face = Face {
//                    let faceRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? face.frame.RotateRight(containerWidth: image.size.width) : face.frame.RotateLeft(containerHeight: image.size.height)
//                    
//                    let portraitImage = image.CropImage(faceRect, padding: 25)
//                    let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingLeftOffset, model.CroppingTopOffset, model.CroppingWidthOffset, model.CroppingHeightOffset, faceRect))
//                    
//                    model.PortraitImage = portraitImage
//                    model.CroppedDocumentImage = croppedDocumentImage
//                }
//                
//                model.DocumentImage = image
                
            
                
                DispatchQueue.main.async {
                    CommonUI.flashBorders(withColor: .green)
                    
                    
                    guard let scannedRect = RectangleDetectionHandler.detectRectangle(image: Constants.frontImage!) else { return }
                    
                    
                    let imageProcessViewController = ImageProcessViewController(image: Constants.frontImage!.withHorizontallyFlippedOrientation(), rect: scannedRect) { (originalImage, croppedImage) in
                        
                        Constants.frontImage = croppedImage
                        
                        IdentityUI.AnimateRotateCard(controller.CameraPreview, completion: { _ in
                        
                        })
                        done()
                         
                    }
                    
                    DispatchQueue.main.async {
                        self.Plan?.controller?.present(imageProcessViewController, animated: true)
                    }

                }
            case .failure(_):
                done()
        }
        
    }
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
    }
    
}


