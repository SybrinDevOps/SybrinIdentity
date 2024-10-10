//
//  GenericDocumentScanPlan.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/17.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
import UIKit
import Foundation

final class GenericDocunentScanPlan: ScanPlan<DocumentModel> {
    
    // MARK: Overrided Properties
    final override var Phases: ScanPhaseList<DocumentModel> {
        return ScanPhaseList(phases: [
            GenericDocumentScanPhase(name: "Generic Document")
        ])
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
        
        DispatchQueue.main.async { [self] in
            switch cutOutType {
                        case .DEFAULT:
                            IdentityUI.AddGenericDocumentOverlay(controller.CameraPreview)
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
