//
//  GenericIDCardBackScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/20.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
import Sybrin_iOS_Common
import AVFoundation
////import MLKit
import MLKitFaceDetection
import Foundation
import UIKit

final class GenericIDCardBackScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    private final var Face: Face?
    private final var LastFace: Face?
    private final var LastFrame: CMSampleBuffer?
    private final var Parser = GenericIDCardParser()
    private final var TextDetectedCounter = 0
    private final let TextDetectedLimit = 3
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // MARK: Overrided Properties
    override final var ThrottleFramesByMilliseconds: Double { get { return 1000 } }
    
    // MARK: Overrided Methods
    final override func PreProcessing(done: @escaping () -> Void) {
        DispatchQueue.main.async {
            CommonUI.updateLabelText(to: NotifyMessage.ScanBackCard.stringValue)
            done()
        }
    }
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        if Model == nil {
            LastFrame = buffer
            TextRecognition(from: buffer)
        } else {
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        if Constants.isManualCapture == true {
            Model = GenericIDCardModel()
            LastFrame = buffer
            TextRecognition(from: buffer)
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
        
        switch result {
            case .success(_):
                guard let model = Model as? GenericIDCardModel else { return }
                guard let frame = LastFrame else { return }
                guard let previousModel = PreviousModel as? GenericIDCardModel else { return }
                
                model.FrontResult = previousModel.FrontResult
                model.DocumentImage = previousModel.DocumentImage
                model.PortraitImage = previousModel.PortraitImage
                model.CroppedDocumentImage = previousModel.CroppedDocumentImage
                
                model.DocumentImagePath = previousModel.DocumentImagePath
                model.PortraitImagePath = previousModel.PortraitImagePath
                model.CroppedDocumentImagePath = previousModel.CroppedDocumentImagePath
                
                //"Cropping and processing image".log(.Debug)
                
                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
                
                model.DocumentBackImage = image
                
                done()
            case .failure(_):
                done()
        }
        
    }
    
//    final override func ProcessTextRecognition(text: Text) {
//        if text.text.count > 0 {
//            
//            if (TextDetectedLimit <= 0) || (TextDetectedLimit > 0 && TextDetectedCounter >= TextDetectedLimit) {
//                
//                Parser.ParseBack(from: text) { [weak self] (model) in
//                    guard let self = self else { return }
//                    
//                    "Found Model".log(.Verbose)
//                    self.Model = model
//                }
//                
//            }else{
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//                    
//                    CommonUI.updateSubLabelText(to: NotifyMessage.ScanningIn(timeRemaining: self.TextDetectedLimit - self.TextDetectedCounter).stringValue)
//                    
//                    self.TextDetectedCounter += 1
//                }
//            }
//            
//            "Found Face".log(.Verbose)
//        } else {
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                self.TextDetectedCounter = 0
//                CommonUI.updateSubLabelText(to: String())
//            }
//        }
//    }
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        LastFrame = nil
        TextDetectedCounter = 0
        
        NotifyUserFrameTime = currentTimeMs
    }
    
}
