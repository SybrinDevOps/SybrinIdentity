//
//  SouthAfricaDriversLicenseScanPlan.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit
import Foundation
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

final class SouthAfricaDriversLicenseScanPlan: ScanPlan<DocumentModel> {
    
    // MARK: Overrided Properties
    final override var Phases: ScanPhaseList<DocumentModel> {
        return ScanPhaseList(phases: [
            SouthAfricaDriversLicenseFrontScanPhase(name: "South Africa Drivers License Front"),
            SouthAfricaDriversLicenseBackScanPhase(name: "South Africa Drivers License Back")
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
            IdentityUI.AddDriversLicenseOverlay(controller.CameraPreview)
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
