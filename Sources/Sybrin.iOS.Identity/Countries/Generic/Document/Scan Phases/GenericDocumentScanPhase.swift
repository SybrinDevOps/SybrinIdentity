//
//  GenericDocumentScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/17.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common
import AVFoundation
//import MLKitVision 
import MLKitFaceDetection
import UIKit

final class GenericDocumentScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    private final var Face: Face?
    private final var LastFace: Face?
    private final var LastFrame: CMSampleBuffer?
    private final var Parser = GenericDocumentParser()
    private final var FaceDetectedCounter = 0
    private final let FaceDetectedLimit = 3
    
    private final var LastFrameImage: UIImage?
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // MARK: Overrided Properties
    override final var ThrottleFramesByMilliseconds: Double { get { return 1000 } }
    
    private var nuModel:GenericDocumentModel?
    
    // MARK: Overrided Methods
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        if Face == nil || Model == nil {
            LastFrame = buffer
        
            FaceDetection(from: buffer)
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
        }
        
        if Constants.isManualCapture == true {
            
            if (LastFrameImage != nil) {
                Constants.frontImage = LastFrameImage?.fixOrientation(to: .up)
            } else {
                Constants.frontImage = LastFrame?.toUIImage(fixOrientation: true)
            }
            
            Constants.isManualCapture = false
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
        
        FaceDetection(from: LastFrame!)
        
        switch result {
            case .success(_):
            
            
            let model = GenericDocumentModel()
            
            
//                guard let model = Model as? GenericDocumentModel else { return }
                guard let frame = LastFrame else { return }
                
                //"Cropping and processing image".log(.Debug)
                
                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
//
                if let face = Face {
                    let faceRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? face.frame.RotateRight(containerWidth: image.size.width) : face.frame.RotateLeft(containerHeight: image.size.height)

                    let portraitImage = image.CropImage(faceRect, padding: 25)
                    let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingLeftOffset, model.CroppingTopOffset, model.CroppingWidthOffset, model.CroppingHeightOffset, faceRect))

                    model.PortraitImage = portraitImage
                    model.CroppedDocumentImage = croppedDocumentImage
                }
//
                model.DocumentImage = image
                self.Model = model
                done()
            case .failure(_):
                done()
        }
        
    }
    
    final override func ProcessFaceDetection(faces: [Face]) {
        
        if faces.count >= 1 {
            let face = faces[0]
            LastFace = face
            
            if (FaceDetectedLimit <= 0) || (FaceDetectedLimit > 0 && FaceDetectedCounter >= FaceDetectedLimit) {
                Face = faces[0]
            }else{
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    CommonUI.updateSubLabelText(to: NotifyMessage.ScanningIn(timeRemaining: self.FaceDetectedLimit - self.FaceDetectedCounter).stringValue)
                    
                    self.FaceDetectedCounter += 1
                }
            }
            
            "Found Face".log(.Verbose)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.FaceDetectedCounter = 0
                CommonUI.updateSubLabelText(to:  String())
            }
        }
    }
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        Face = nil
        LastFrame = nil
        FaceDetectedCounter = 0
        
        NotifyUserFrameTime = currentTimeMs
    }
    
}
