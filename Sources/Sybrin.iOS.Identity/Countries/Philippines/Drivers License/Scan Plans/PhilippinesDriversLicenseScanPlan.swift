//
//  PhilippinesDriversLicenseScanPlan.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

final class PhilippinesDriversLicenseScanPlan: ScanPlan<DocumentModel> {
    
    
    var list: ScanPhaseList<DocumentModel> {
        switch hasBackSide {
        case .DEFAULT:
            return ScanPhaseList(phases: [
                PhilippinesDriversLicenseFrontScanPhase(name: "Philippines Drivers License Front"),
                PhilippinesDriversLicenseBackScanPhase(name: "Philippines Drivers License Back"),
                PhilippinesDriversLicenseNetworkPhase(name: "confirm")
            ])
        case .TRUE:
            return ScanPhaseList(phases: [
                PhilippinesDriversLicenseFrontScanPhase(name: "Philippines Drivers License Front"),
                PhilippinesDriversLicenseBackScanPhase(name: "Philippines Drivers License Back"),
                PhilippinesDriversLicenseNetworkPhase(name: "confirm")
            ])
        case .FALSE:
            return ScanPhaseList(phases: [
                PhilippinesDriversLicenseFrontScanPhase(name: "Philippines Drivers License Front", hasBackSide: hasBackSide),
                PhilippinesDriversLicenseNetworkPhase(name: "confirm")
            ])
        default:
            return ScanPhaseList(phases: [
                PhilippinesDriversLicenseFrontScanPhase(name: "Philippines Drivers License Front"),
                PhilippinesDriversLicenseBackScanPhase(name: "Philippines Drivers License Back"),
                PhilippinesDriversLicenseNetworkPhase(name: "confirm")
            ])
        }

    }
    
    // MARK: Overrided Properties
    final override var Phases: ScanPhaseList<DocumentModel> {
        
        return list
        
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
        
//        DispatchQueue.main.async {
//            IdentityUI.AddDriversLicenseOverlay(controller.CameraPreview)
//            done()
//        }
        
        DispatchQueue.main.async { [self] in
            switch cutOutType {
                        case .DEFAULT:
                            IdentityUI.AddDriversLicenseOverlay(controller.CameraPreview)
                        case .PASSPORT:
                            IdentityUI.AddPassportOverlay(controller.CameraPreview)
                        case .ID_CARD:
                            IdentityUI.AddIDCardOverlay(controller.CameraPreview)
                        case .ACCESS_CARD:
                            IdentityUI.AddAccessCardOverlay(controller.CameraPreview)
                        case .A4:
                            IdentityUI.AddA4DocumentOverlay(controller.CameraPreview)
                        case .BOOK:
                            IdentityUI.AddBookDocumentOverlay(controller.CameraPreview)
                        case .NONE:
                            IdentityUI.AddGenericDocumentOverlay(controller.CameraPreview)
                        case .A4_LANDSCAPE:
                            IdentityUI.AddA4LandscapeDocumentOverlay(controller.CameraPreview)
                        default:
                            IdentityUI.AddGenericDocumentOverlay(controller.CameraPreview)
                        }

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
