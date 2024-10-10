//
//  PhilippinesSeafarerIdentificationDocumentFrontScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import UIKit
import UIKit

final class PhilippinesIdentificationCardFrontScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
//    private final var Face: Face?
    private final var LastFrame: CMSampleBuffer?
    private final var LastFrameImage: UIImage?
//    private final var Parser = PhilippinesIdentificationCardParser()
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    private final let TextDetectedLimit = 3
    private final var TextDetectedCounter = 0
    
    // MARK: Overrided Methods
    final override func ProcessFrame(buffer: CMSampleBuffer) {

        if Model == nil {
            LastFrame = buffer
 
            //FaceDetection(from: buffer)

            if Model == nil {
                TextRecognition(from: buffer)
            }
        } else {
            
            if (LastFrameImage != nil) {
                Constants.frontImage = LastFrameImage?.fixOrientation(to: .up)
            } else {
                Constants.frontImage = LastFrame?.toUIImage(fixOrientation: true)
            }
            
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
            Constants.isManualCapture = false
        }

        if Constants.isManualCapture == true {
            if (LastFrameImage != nil) {
                Constants.frontImage = LastFrameImage
            } else {
                Constants.frontImage = LastFrame?.toUIImage(fixOrientation: true)
            }
            Constants.isManualCapture = false
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
    
    final override func ProcessImage(image: UIImage) {
        
        if Model == nil {
            LastFrameImage = image
            FaceDetectionManualImage(from: image)
            if Model == nil {
                TextRecognitionManualImage(from: image)
            }
        } else {
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
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
            
                var model: PhilippinesIdentificationCardModel?
            
                if Model == nil {
                    model = PhilippinesIdentificationCardModel()
                } else {
                    model = Model as? PhilippinesIdentificationCardModel
                }
            
                guard let model = model else { return }
                guard let frame = LastFrame else { return }
                
                //"Cropping and processing image".log(.Debug)
                
                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
                
                model.DocumentImage = image
                
                DispatchQueue.main.async {
                    CommonUI.updateLabelText(to: NotifyMessage.NiceYouGotIt.stringValue)
                    
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
