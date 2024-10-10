//
//  SouthAfricaIDCardScanPlan.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

final class SouthAfricaIDCardScanPlan: ScanPlan<DocumentModel> {
    
    // MARK: Overrided Properties
    final override var Phases: ScanPhaseList<DocumentModel> {
        return ScanPhaseList(phases: [
            SouthAfricaIDCardFrontScanPhase(name: "South Africa ID Card Front"),
            //SouthAfricaIDCardFrontCropPhase(name: "South Africa ID Card Front"),
            SouthAfricaIDCardBackScanPhase(name: "South Africa ID Card Back"),
            SouthAfricaIDCardNetworkPhase(name: "South Africa ID Extraction")
        ])
    }
    final override var CameraOptionsObj: CameraOptions {
        var cameraOptions = CameraOptions()
        cameraOptions.maximumFramesPerSecond = 60
        cameraOptions.minimumFramesPerSecond = 30
        cameraOptions.maximumResolution = nil
        cameraOptions.minimumResolution = CGSize(width: 1080, height: 1920)
        cameraOptions.include16by9AspectRatios = true
        cameraOptions.include4by3AspectRatios = false
        cameraOptions.includeOtherAspectRatios = false
        cameraOptions.preference = .Resolution
        return cameraOptions
    }
    
    // MARK: Private Methods
    private final func SaveImages() {
        guard let model = currentPhase?.Model else { return }
        
        if SybrinIdentity.shared.configuration?.saveImages ?? SybrinIdentityConfiguration.SaveImages {
            model.saveImages()
        }
    }
    
    // MARK: Overrided Methods
    final override func ConfigureUI(done: @escaping () -> Void) {
        guard let controller = controller else { return }
        
        DispatchQueue.main.async {
            IdentityUI.AddIDCardOverlay(controller.CameraPreview)
            done()
        }
    }
    
    override final func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        switch result {
            case .success(_):
                SaveImages()
                done()
            case .failure(_):
                done()
        }
    }
    
}
