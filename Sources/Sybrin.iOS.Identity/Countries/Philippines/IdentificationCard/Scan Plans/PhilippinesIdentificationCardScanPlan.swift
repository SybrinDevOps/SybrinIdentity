////
////  PhilippinesIdentificationCardScanPlan.swift
////  Sybrin.iOS.Identity
////
////  Created by Default on 2022/05/04.
////  Copyright © 2022 Sybrin Systems. All rights reserved.
////
//
//import UIKit
//
//class PhilippinesIdentificationCardScanPlan: ScanPlan<DocumentModel> {
//    // MARK: Overrided Properties
//    final override var Phases: ScanPhaseList<DocumentModel> {
//        return ScanPhaseList(phases: [
//            PhilippinesIdentificationCardFrontScanPhase(name: "Philippines Identification Card Front"),
//            PhilippinesIdentificationCardScanNewBackPhase(name: "Philippines Identification Card Back")
//            //PhilippinesIdentificationCardBackScanPhase(name: "Philippines Identification Card Back")
//        ])
//    }
//    
//    // MARK: Private Methods
//    private final func SaveImages() {
//        guard let model = currentPhase?.Model else { return }
//        
//        if SybrinIdentity.shared.configuration?.saveImages ?? SybrinIdentityConfiguration.SaveImages {
//            model.saveImages()
//        }
//    }
//    
//    // MARK: Overrided Methods
//    final override func ConfigureUI(done: @escaping () -> Void) {
//        guard let controller = controller else { return }
//        
//        DispatchQueue.main.async {
//            IdentityUI.AddIDCardOverlay(controller.CameraPreview)
//            done()
//        }
//    }
//    
//    override final func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
//        switch result {
//            case .success(_):
//                SaveImages()
//                done()
//            case .failure(_):
//                done()
//        }
//    }
//}
