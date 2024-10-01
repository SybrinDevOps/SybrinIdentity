//
//  ScanPlan.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import AVFoundation
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

class ScanPlan<T> {
    
    // MARK: Internal Properties
    final var name: String { get { return Name } }
    final var status: ScanPlanStatus { get { return Status } }
    final var controller: ScanViewController? { get { return Controller } }
    final var cropController: ImageProcessViewController? { get { return CropController } }
    final var mlKit: MLKitHandler? { get { return MLKit } }
    final var camera: CameraHandler? { get { return Camera } }
    final var currentPhase: ScanPhase<T>? { get { return PhasesList?.activePhase } }
    
    //
    final var cutOutType: CutOutType { get { return CutOut_Type ?? CutOutType.DEFAULT} }
    final var hasBackSide: HasBackSide { get { return HasBack_Side ?? HasBackSide.DEFAULT} }

    
    // MARK: Private Properties
    private final var Name: String
    private final var Status: ScanPlanStatus = .PlanCreated
    private final weak var Controller: ScanViewController?
    private final weak var CropController: ImageProcessViewController?
    private final weak var Delegate: ScanPlanDelegate?
    private final var Camera: CameraHandler?
    private final var MLKit: MLKitHandler?
    private final var PhasesList: ScanPhaseList<T>?
    
    //
    private final var CutOut_Type: CutOutType?
    private final var HasBack_Side: HasBackSide?

    
    // MARK: Overridable Properties
    var Phases: ScanPhaseList<T> { get { return ScanPhaseList() } }
    var ControllerTag: Int { get { return IdentityUITags.IDENTITY_UI_TAG.rawValue } }
    var CameraOptionsObj: CameraOptions {
        var cameraOptions = CameraOptions()
        cameraOptions.maximumFramesPerSecond = 60
        cameraOptions.minimumFramesPerSecond = 30
        cameraOptions.maximumResolution = CGSize(width: 1080, height: 1920)
        cameraOptions.minimumResolution = CGSize(width: 720, height: 1280)
        cameraOptions.include16by9AspectRatios = true
        cameraOptions.include4by3AspectRatios = false
        cameraOptions.includeOtherAspectRatios = false
        cameraOptions.preference = .Resolution
        return cameraOptions
    }
    
    // MARK: Initializers
    init(name: String, controller: ScanViewController, cutOutType: CutOutType = .DEFAULT, hasBackSide: HasBackSide = .DEFAULT)  {
        Name = name
        HasBack_Side = hasBackSide
        Delegate = controller
        Controller = controller
        PhasesList = Phases
        CutOut_Type = cutOutType
        //CropController = cropController
        
        
        if let PhasesList = PhasesList {
            PhasesList.forEach { (phase) in
                phase.Delegate = self
                phase.Plan = self
            }
        }
    }
    
    // MARK: Internal Methods
    final func Start() {
        guard Status == .PlanReady else {
            Initialize { [weak self] in
                guard let self = self else { return }
                
                self.Start()
            }
            return
        }
        
        guard Status == .PlanReady else { return }
        
        PreProcessing { [weak self] in
            guard let self = self else { return }
            
            "Starting scan plan".log(.Debug)
            
            self.Delegate?.PlanStarted()
            
            self.GoToNextPhase()
        }
        
    }
    
    final func Reset() {
        guard let PhasesList = PhasesList else { return }
        
        "Resetting scan plan".log(.Debug)
        
        Status = .PlanCreated
        let _ = PhasesList.goTo(index: 0)
        PhasesList.forEach { (scanPhase) in
            scanPhase.Reset()
        }
        
        Camera = nil
        //MLKit = nil
    }
    
    final func Restart() {
        "Restarting scan plan".log(.Debug)
        
        Reset()
        Start()
    }
    
    final func GoToNextPhase() {
        guard let PhasesList = PhasesList else { return }
        
        if let _ = PhasesList.next() {
            "Going to next phase".log(.Debug)
            
            StartPhase()
        } else {
            "No more phases left, scan plan complete".log(.Debug)
            
            CompletePlan()
        }
    }
    
    final func GoToPreviousPhase(with reason: ScanFailReason) {
        guard let PhasesList = PhasesList else { return }
        
        if let phase = PhasesList.previous() {
            "Going back to previous phase".log(.Debug)
            
            phase.Reset()
            
            StartPhase()
        } else {
            "No more phases left, scan plan failed".log(.Debug)
            
            FailPlan(with: reason)
        }
    }
    
    
    // MARK: Private Methods
    private final func Initialize(done: @escaping () -> Void) {
        DispatchQueue.main.async { [unowned self] in
            
            guard let PhasesList = PhasesList else { return }
            guard let controller = Controller else { return }
            //guard let cropController = CropController else { return }
            
            "Initializing scan plan".log(.Debug)
            
            guard Status == .PlanCreated else { return }
            
            guard PhasesList.count > 0 else { return FailPlan(with: .NoPhases) }
            
            "Configuring controller".log(.Debug)
            
            controller.view.tag = ControllerTag
            
            "Setting branding labels and UI colors".log(.Debug)
            
            controller.HeadingBrandingLabel.text = SybrinIdentity.shared.configuration?.overlayBrandingTitleText ?? SybrinIdentityConfiguration.OverlayBrandingTitleText
            controller.HeadingBrandingLabel.textColor = SybrinIdentity.shared.configuration?.overlayBrandingTitleColor ?? SybrinIdentityConfiguration.OverlayBrandingTitleColor
            controller.SubtitleBrandingLabel.text = SybrinIdentity.shared.configuration?.overlayBrandingSubtitleText ?? SybrinIdentityConfiguration.OverlayBrandingTitleText
            controller.SubtitleBrandingLabel.textColor = SybrinIdentity.shared.configuration?.overlayBrandingSubtitleColor ?? SybrinIdentityConfiguration.OverlayBrandingSubtitleColor
            
            let enableBackButton = SybrinIdentity.shared.configuration?.enableBackButton ?? SybrinIdentityConfiguration.EnableBackButton
            let enableSwipeRightGesture = SybrinIdentity.shared.configuration?.enableSwipeRightGesture ?? SybrinIdentityConfiguration.EnableSwipeRightGesture
            let showFlashButton = SybrinIdentity.shared.configuration?.showFlashButton ?? SybrinIdentityConfiguration.ShowFlashButton
            let cameraPosition = SybrinIdentity.shared.configuration?.cameraPosition ?? SybrinIdentityConfiguration.CameraPosition
            
            "Configuring GestureHandler".log(.Debug)
            
            if enableSwipeRightGesture {
                GestureHandler.delegate = self
                GestureHandler.addSwipeGesture(on: controller.CameraPreview, for: .right)
            }
            
            "Configuring MLKitHandler".log(.Debug)
            
            MLKit = MLKitHandler()
            
            "Configuring CameraHandler".log(.Debug)
            
            Camera = CameraHandler(controller.CameraPreview, cameraPosition: cameraPosition, cameraOptions: CameraOptionsObj)
            Camera?.outputType = .CMSampleBuffer
            
            "Configuring UI".log(.Debug)
            
            ConfigureUI { [weak self] in
                guard let self = self else { return }
                
                "Configuring CommonUI".log(.Debug)
                
                if enableBackButton || showFlashButton {
                    CommonUI.delegate = self
                    if enableBackButton {
                        CommonUI.addBackButton(to: nil)
                    }
                    if showFlashButton && cameraPosition == .back {
                        CommonUI.addFlashLightButton(to: nil)
                    }
                }
                
                "Initialized scan plan".log(.Debug)
                
                self.Status = .PlanReady
                
                done()
            }
        }
    }
    
    private final func StartPhase() {
        guard let phase = currentPhase else { return }
        guard let MLKit = MLKit else { return }
        guard let Camera = Camera else { return }
        
        let previousPhase = phase.PreviousPhase
        
        if previousPhase != nil {
            "Changing phases".log(.Debug)
            Status = .PlanChangingPhases
            Delegate?.PlanChangingPhases(from: previousPhase!)
        }
        
        "Setting MLKitHandler delegate".log(.Debug)
        
        MLKit.Delegate = phase
        
        "Setting CameraHandler delegate".log(.Debug)
        
        Camera.delegate = phase
        
        "Starting phase".log(.Debug)
        
        if previousPhase != nil {
            Delegate?.PlanChangedPhases(to: phase)
        }
        
        Status = .PlanProcessing
        
        phase.Start()
    }
    
    private final func CompletePlan() {
        guard let PhasesList = PhasesList else { return }
        guard let controller = Controller else { return }
        
        PostProcessing(for: .success(true)) { [weak self] in
            guard let self = self else { return }
            guard let model = PhasesList.last?.Model else { return }
            
            "Scan plan completed".log(.Debug)
            
            self.Reset()
            controller.DismissUI(with: self.ControllerTag) { [weak self] in
                guard let self = self else { return }
                
                self.Status = .PlanCompleted
                self.Delegate?.PlanCompleted(with: model)
                
                CommonUI.removeOverlay()
            }
            
        }
    }
    
    private final func FailPlan(with reason: ScanFailReason) {
        guard let controller = Controller else { return }
        
        PostProcessing(for: .failure(reason)) { [weak self] in
            guard let self = self else { return }
            
            "Scan plan failed".log(.Debug)
            "Reason: \(reason)".log(.Verbose)
            
            self.Reset()
            controller.DismissUI(with: self.ControllerTag) { [weak self] in
                guard let self = self else { return }
                
                self.Status = .PlanFailed
                self.Delegate?.PlanFailed(with: reason)
                
                CommonUI.removeOverlay()
            }
            
        }
    }
    
    // MARK: Overridable Methods
    func ConfigureUI(done: @escaping () -> Void) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
        done()
    }
    
    func PreProcessing(done: @escaping () -> Void) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
        done()
    }
    
    func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
        done()
    }

}

// MARK: - Extensions

extension ScanPlan: CommonUIDelegate {
    
    final func handleBackButtonPressed() {
        guard Status == .PlanProcessing else { return }
        guard let controller = Controller else { return }
        
        Reset()
        controller.DismissUI(with: ControllerTag) { [weak self] in
            guard let self = self else { return }
            
            self.Delegate?.PlanCanceled()
            CommonUI.removeOverlay()
        }
    }
    
}

extension ScanPlan: SwipeGestureDelegate {
    
    final func handleSwipeRight() {
        guard Status == .PlanProcessing else { return }
        guard let controller = Controller else { return }
        
        Reset()
        controller.DismissUI(with: ControllerTag) { [weak self] in
            guard let self = self else { return }
            
            self.Delegate?.PlanCanceled()
            CommonUI.removeOverlay()
        }
    }
    
}

extension ScanPlan: ScanPhaseDelegate {
    
    final func PhasePausedProcessing() {
        guard let phase = currentPhase else { return }
        
        Status = .PlanPaused
        Delegate?.PlanPaused(at: phase)
    }
    
    final func PhaseResumedProcessing() {
        guard let phase = currentPhase else { return }
        
        Status = .PlanProcessing
        Delegate?.PlanResumed(at: phase)
    }
    
    final func PhaseCompleted() {
        GoToNextPhase()
    }
    
    final func PhaseFailed(with reason: ScanFailReason, critical: Bool) {
        if !critical {
            GoToPreviousPhase(with: reason)
        } else {
            FailPlan(with: reason)
        }
    }

}
