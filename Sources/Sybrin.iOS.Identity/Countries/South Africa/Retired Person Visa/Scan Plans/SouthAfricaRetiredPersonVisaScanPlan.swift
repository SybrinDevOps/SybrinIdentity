////
////  SouthAfricaRetirementVisaScanPlan.swift
////  Sybrin.iOS.Identity
////
////  Created by Armand Riley on 2021/09/01.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
//import UIKit
//
//final class SouthAfricaRetiredPersonVisaScanPlan: ScanPlan<DocumentModel> {
//    
//    // MARK: Overrided Properties
//    final override var Phases: ScanPhaseList<DocumentModel> {
//        return ScanPhaseList(phases: [
//            SouthAfricaRetiredPersonVisaScanPhase(name: "South Africa Retired Person Visa")
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
//            IdentityUI.AddVisaOverlay(controller.CameraPreview)
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
//    
//}
