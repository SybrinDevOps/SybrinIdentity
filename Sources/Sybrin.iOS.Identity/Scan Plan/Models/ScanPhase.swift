//
//  ScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common
import AVFoundation
import MLKitFaceDetection ////import MLKit
import UIKit

class ScanPhase<T>: CameraDelegate, HandleMLKitResponse {
    
    // MARK: Internal Properties
    final var name: String { get { return Name } }
    final var hasBackSide: HasBackSide { get { return HasBack_Side}}
    //final var cutOutType: CutOutType { get { return CutOut_Type ?? CutOutType.DEFAULT}}
    final var status: ScanPhaseStatus { get { return Status } }
    final weak var Delegate: ScanPhaseDelegate?
    
    final weak var Plan: ScanPlan<T>?
    final var NextPhase: ScanPhase<T>?
    final weak var PreviousPhase: ScanPhase<T>?
    
    final var Model: T?
    final var PreviousModel: T? { get { return PreviousPhase?.Model } }
    
    // Throttling
    final var FrameCounter = 0
    final var PreviousFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    final var PreviousFaceDetectionFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    final var PreviousTextRecognitionFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    final var PreviousBarcodeScanningFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    
    // MARK: Private Properties
    private final var Name: String
    private final var Status: ScanPhaseStatus = .PhaseCreated
    private final var HasBack_Side: HasBackSide
    //private final var CutOut_Type: CutOutType?
    
    
    private final var PreviousFrameCount = 0
    private final var PreviousFPSCount: Double = Date().timeIntervalSince1970 * 1000
    
    // MARK: Overridable Properties
    var MinimumFrameCount: Int { get { return 5 } }
    var ThrottleFramesByMilliseconds: Double { get { return 0 } }
    var ThrottleFaceDetectionFramesByMilliseconds: Double { get { return 0 } }
    var ThrottleTextRecognitionFramesByMilliseconds: Double { get { return 0 } }
    var ThrottleBarcodeScanningFramesByMilliseconds: Double { get { return 0 } }
    
    var popupClosed = false;
    
    // MARK: Initializers
    init(name: String/*, cutOut_type: CutOutType = .DEFAULT*/, hasBackSide: HasBackSide = .DEFAULT) {
        Name = name
        //CutOut_Type = cutOut_type
        HasBack_Side = hasBackSide
    }
    
    // MARK: Internal Methods
    final func Vibrate(count: Int) {
        if count == 0 {
            return
        }
        let soundID: SystemSoundID = 1108;
        AudioServicesPlaySystemSoundWithCompletion(/*kSystemSoundID_Vibrate*/soundID) { [weak self] in
            self?.Vibrate(count: count - 1)
        }
        
        //SystemSoundID soundID = 1108;

//        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
//            AudioServicesDisposeSystemSoundID(soundID);
//        });
    }
    
    final func Start() {
        guard Status == .PhaseReady else {
            Initialize { [weak self] in
                guard let self = self else { return }
                
                self.Start()
            }
            return
        }
        
        guard Status == .PhaseReady else { return }
        
        "Starting scan phase".log(.Debug)
        
        Status = .PhasePreProcessing
        
        "Starting scan phase pre processing".log(.Debug)
        
        PreProcessing { [weak self] in
            guard let self = self else { return }

            "Starting scan phase processing".log(.Debug)
            
            self.Delegate?.PhaseStartedProcessing()
            
            self.Status = .PhaseProcessing
        }
    }
    
    final func Pause() {
        guard Status == .PhaseProcessing else { return }
        
        "Pausing scan phase".log(.Debug)
        
        Status = .PhasePaused
        Delegate?.PhasePausedProcessing()
    }
    
    final func Resume() {
        guard Status == .PhasePaused else { return }
        
        "Resuming scan phase".log(.Debug)
        
        Status = .PhaseProcessing
        Delegate?.PhaseResumedProcessing()
    }
    
    final func Reset() {
        "Resetting scan phase".log(.Debug)
        
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        Status = .PhaseCreated
        Model = nil
        FrameCounter = 0
        PreviousFrameTime = currentTimeMs
        PreviousFaceDetectionFrameTime = currentTimeMs
        PreviousTextRecognitionFrameTime = currentTimeMs
        PreviousBarcodeScanningFrameTime = currentTimeMs
        
        "Resetting scan phase data".log(.Debug)
        
        ResetData()
    }
    
    final func Restart() {
        "Restarting scan phase".log(.Debug)
        
        Reset()
        Start()
    }
    
    final func Complete() {
        guard Status == .PhaseProcessing || Status == .PhasePreProcessing || Status == .PhasePostProcessing else { return }
        
        Finalize(for: .success(true)) { [weak self] in
            guard let self = self else { return }
            
            self.CompleteAfterPostProcessing()
            self.Vibrate(count: 1)
        }
    }
    
    final func Fail(with reason: ScanFailReason, critical: Bool = false) {
        guard Status == .PhaseProcessing || Status == .PhasePreProcessing || Status == .PhasePostProcessing else { return }
        
        Finalize(for: .failure(reason)) { [weak self] in
            guard let self = self else { return }
            
            self.FailAfterPostProcessing(with: reason, critical: critical)
        }
    }
    
    // MARK: MLKit Methods
    final func FaceDetection(from buffer: CMSampleBuffer) {
        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousFaceDetectionFrameTime) >= ThrottleFaceDetectionFramesByMilliseconds else { return }
        PreviousFaceDetectionFrameTime = currentTimeMs
        
        "Running face detection on frame \(FrameCounter)".log(.Debug)
        mlKit.FaceDetectionUsingBufferRealtime(buffer)
    }
    
    final func FaceDetectionManual(from buffer: CMSampleBuffer) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousFaceDetectionFrameTime) >= ThrottleFaceDetectionFramesByMilliseconds else { return }
        PreviousFaceDetectionFrameTime = currentTimeMs
        
        "Running face detection on frame \(FrameCounter)".log(.Debug)
//        mlKit.FaceDetectionUsingBuffer(buffer) { val in
//
//        }
    }
    
    final func FaceDetectionManualImage(from image: UIImage) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousFaceDetectionFrameTime) >= ThrottleFaceDetectionFramesByMilliseconds else { return }
        PreviousFaceDetectionFrameTime = currentTimeMs
        
        "Running face detection on frame \(FrameCounter)".log(.Debug)
//        mlKit.FaceDetectionUsingImage(image) { val in
//
//        }
    }
    
    final func TextRecognition(from buffer: CMSampleBuffer) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousTextRecognitionFrameTime) >= ThrottleTextRecognitionFramesByMilliseconds else { return }
        PreviousTextRecognitionFrameTime = currentTimeMs
        
//        "Running text recognition on frame \(FrameCounter)".log(.Debug)
//        mlKit.TextRecognitionUsingBufferRealtime(buffer)
    }
    
    final func TextRecognitionManual(from buffer: CMSampleBuffer) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousTextRecognitionFrameTime) >= ThrottleTextRecognitionFramesByMilliseconds else { return }
        PreviousTextRecognitionFrameTime = currentTimeMs
        
        "Running text recognition on frame \(FrameCounter)".log(.Debug)
//        mlKit.TextRecognitionUsingBuffer(buffer) { _ in
//
//        }
    }
    
    final func TextRecognitionManualImage(from image: UIImage) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousTextRecognitionFrameTime) >= ThrottleTextRecognitionFramesByMilliseconds else { return }
        PreviousTextRecognitionFrameTime = currentTimeMs
        
        "Running text recognition on frame \(FrameCounter)".log(.Debug)
//        mlKit.TextRecognitionUsingImage(image) { _ in
//
//        }
    }
    
    final func BarcodeScanning(from buffer: CMSampleBuffer) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousBarcodeScanningFrameTime) >= ThrottleBarcodeScanningFramesByMilliseconds else { return }
        PreviousBarcodeScanningFrameTime = currentTimeMs
        
        "Running barcode scanning on frame \(FrameCounter)".log(.Debug)
        //mlKit.BarcodeScanningUsingBufferRealtime(buffer)
    }
    
    final func BarcodeScanningManual(from buffer: CMSampleBuffer) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousBarcodeScanningFrameTime) >= ThrottleBarcodeScanningFramesByMilliseconds else { return }
        PreviousBarcodeScanningFrameTime = currentTimeMs
        
        "Running barcode scanning on frame \(FrameCounter)".log(.Debug)
//        mlKit.BarcodeScanningUsingBuffer(buffer) { _ in
//
//        }
    }
    
    final func BarcodeScanningManualImage(from image: UIImage) {
//        guard let mlKit = Plan?.mlKit else { return }
        
        // Throtteling detection if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousBarcodeScanningFrameTime) >= ThrottleBarcodeScanningFramesByMilliseconds else { return }
        PreviousBarcodeScanningFrameTime = currentTimeMs
        
        "Running barcode scanning on frame \(FrameCounter)".log(.Debug)
//        mlKit.BarcodeScanningUsingImage(image) { _ in
//            
//        }
    }
    
    // MARK: Private Methods
    private final func Initialize(done: @escaping () -> Void) {
        
        "Initializing scan phase".log(.Debug)
        
        guard Status == .PhaseCreated else { return }
        
        "Configuring UI".log(.Debug)
        
        ConfigureUI { [weak self] in
            guard let self = self else { return }
            "Initialized scan phase".log(.Debug)
            
            self.Status = .PhaseReady
            
            done()
        }
    }
    
    private final func Finalize(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        
        "Starting scan phase post processing".log(.Debug)
        
        Status = .PhasePostProcessing
        
        PostProcessing(for: result) {
            done()
        }
    }
    
    private final func CompleteAfterPostProcessing() {
        "Scan phase completed".log(.Debug)
        
        self.Status = .PhaseCompleted
        
        self.Delegate?.PhaseCompleted()
    }
    
    private final func FailAfterPostProcessing(with reason: ScanFailReason, critical: Bool = false) {
        "Scan phase failed".log(.Debug)
        
        self.Status = .PhaseFailed
        
        self.Delegate?.PhaseFailed(with: reason, critical: critical)
        
        self.Reset()
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
    
    func ProcessFrame(buffer: CMSampleBuffer) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
    }
    
    func ProcessImage(image: UIImage) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
    }
    
    func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
        done()
    }
    
    func ResetData() {
        "\(#function) not implemented (\(Name))".log(.Verbose)
    }
    
    func ProcessFaceDetection(faces: [Face]) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
    }
    
    func ProcessTextRecognition(/*text: Text*/) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
    }
    
    func ProcessBarcodeScanning(/*barcodes: [Barcode]*/) {
        "\(#function) not implemented (\(Name))".log(.Verbose)
    }
    
    // MARK: Camera Delegate Methods
    public final func processFrameCMSampleBuffer(_ cmbuffer: CMSampleBuffer) {
        guard Status == .PhaseProcessing else { return }
        
        FrameCounter += 1
        
        let currentTime = Date().timeIntervalSince1970 * 1000
        if currentTime > PreviousFPSCount + 1000 {
            "Processing frame \(FrameCounter) (\(cmbuffer.width)x\(cmbuffer.height) @ \((FrameCounter - PreviousFrameCount)) fps)".log(.Verbose)
            PreviousFPSCount = currentTime
            PreviousFrameCount = FrameCounter
        }
        
        guard FrameCounter >= MinimumFrameCount else { return }
        
        // Throtteling if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousFrameTime) >= ThrottleFramesByMilliseconds else { return }
        PreviousFrameTime = currentTimeMs
        
        guard let camera = Plan?.camera else { return }
        
        guard !camera.isCameraBusy else { return }
        
        ProcessFrame(buffer: cmbuffer)
    }
    
    public final func ProcessFrameImage(_ image: UIImage) {
        guard Status == .PhaseProcessing else { return }
        
        FrameCounter += 1
        
        let currentTime = Date().timeIntervalSince1970 * 1000
        if currentTime > PreviousFPSCount + 1000 {
            "Processing frame \(FrameCounter) (\(image.size.width)x\(image.size.height) @ \((FrameCounter - PreviousFrameCount)) fps)".log(.Verbose)
            PreviousFPSCount = currentTime
            PreviousFrameCount = FrameCounter
        }
        
        guard FrameCounter >= MinimumFrameCount else { return }
        
        // Throtteling if needed
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        guard (currentTimeMs - PreviousFrameTime) >= ThrottleFramesByMilliseconds else { return }
        PreviousFrameTime = currentTimeMs
        
        guard let camera = Plan?.camera else { return }
        
        guard !camera.isCameraBusy else { return }
        
        ProcessImage(image: image)
    }
    
    
    
    // MARK: ML Kit Response Delegate
    final func handleFaceDetectionResult(_ result: [Face]) {
        guard Status == .PhaseProcessing else { return }
        
        ProcessFaceDetection(faces: result)
    }
    
    final func handleTextRecognitionResult(/*_ result: Text*/) {
        guard Status == .PhaseProcessing else { return }
        
        //ProcessTextRecognition(text: result)
    }
    
    final func handleBarcodeScanningResult(/*_ result: [Barcode]*/) {
        guard Status == .PhaseProcessing else { return }
        
//        ProcessBarcodeScanning(barcodes: result)
    }
    
    final func handleError(_ error: Error) {
        "Received error from MLKit".log(.ProtectedError)
        "Error: \(error.localizedDescription)".log(.Verbose)
    }
    let popupView = UIView()
    
    func showPopup(view: UIView) {
        
        if (popupClosed == true) {
            popupView.isHidden = true
            
            return
        }
            
            popupView.translatesAutoresizingMaskIntoConstraints = false
            popupView.layer.name = "popup_view"
            popupView.backgroundColor = .white
            popupView.layer.cornerRadius = 10
            popupView.layer.shadowColor = UIColor.black.cgColor
            popupView.layer.shadowOpacity = 0.5
            popupView.layer.shadowOffset = CGSize(width: 0, height: 10)
            popupView.layer.shadowRadius = 10

            view.addSubview(popupView)

            NSLayoutConstraint.activate([
                popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                popupView.widthAnchor.constraint(equalToConstant: 300),
                popupView.heightAnchor.constraint(equalToConstant: 300)
            ])

            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = "Image Quality Guidelines"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textColor = .gray

            popupView.addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
                titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor)
            ])

            let guidelines = [
                "Ensure Good Lighting",
                "Keep Document Flat and Still",
                "Frame Entire Document",
                "Avoid Blurry Images",
                "Remove Obstructions"
            ]

            var lastLabel: UILabel?
            lastLabel?.textColor = .black

            for (index, guideline) in guidelines.enumerated() {
                let numberLabel = UILabel()
                numberLabel.translatesAutoresizingMaskIntoConstraints = false
                numberLabel.text = "\(index + 1)"
                numberLabel.font = UIFont.boldSystemFont(ofSize: 18)
                numberLabel.textColor = .black

                popupView.addSubview(numberLabel)

                NSLayoutConstraint.activate([
                    numberLabel.topAnchor.constraint(equalTo: lastLabel?.bottomAnchor ?? titleLabel.bottomAnchor, constant: 20),
                    numberLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20)
                ])

                let guidelineLabel = UILabel()
                guidelineLabel.translatesAutoresizingMaskIntoConstraints = false
                guidelineLabel.text = guideline
                guidelineLabel.numberOfLines = 0
                guidelineLabel.textColor = .black

                popupView.addSubview(guidelineLabel)

                NSLayoutConstraint.activate([
                    guidelineLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
                    guidelineLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 10),
                    guidelineLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20)
                ])

                lastLabel = guidelineLabel
            }

            let button = PopupButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Got it", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.associatedView = view
            button.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)

            popupView.addSubview(button)

            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: lastLabel?.bottomAnchor ?? titleLabel.bottomAnchor, constant: 20),
                button.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20)
            ])
        }

    @objc func dismissPopup(_ sender: PopupButton) {
        if let popupView = self.Plan!.controller?.CameraPreview.subview(where: { $0.layer.name == "popup_view" }) {
                popupView.removeFromSuperview()
            popupView.isHidden = true;
            }
        
        popupClosed = true;
        
//        self.Plan!.controller?.CameraPreview.sub
        }
    
}


class PopupButton: UIButton {
    var associatedView: UIView?
}
