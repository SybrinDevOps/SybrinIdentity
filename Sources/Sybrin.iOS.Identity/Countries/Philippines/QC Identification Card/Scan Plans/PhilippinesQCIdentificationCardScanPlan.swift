//
//  PhillippinesQCIdentificationCardScanPlan.swift
//  Sybrin.iOS.Identity
//
//  Created by Matthew Dickson on 2022/11/08.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//

import UIKit

final class PhilippinesQCIdentificationCardScanPlan: ScanPlan<DocumentModel> {
    
    // MARK: Overrided Properties
    final override var Phases: ScanPhaseList<DocumentModel> {
        return ScanPhaseList(phases: [
            PhilippinesQCIdentificationCardFrontScanPhase(name: "Philippines QC Identificaion Card Front"),
            PhilippinesQCIdentificationCardBackScanPhase(name: "Philippines QC Identificaion Card Back"),
            PhilippinesQCIdentificationCardBackNetworkPhase(name: "Confirm")
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

