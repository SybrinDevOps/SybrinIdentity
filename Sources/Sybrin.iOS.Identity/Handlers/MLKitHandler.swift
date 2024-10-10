//
//  MLKitHandler.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/21.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import Foundation
import MLKitFaceDetection //import MLKit
import AVFoundation

import MLKitVision 
import MLKitBarcodeScanning
import Sybrin_iOS_Common

final class MLKitHandler {
    
    // MARK: Private Properties
//    private final let TextRecognizerObj = TextRecognizer.textRecognizer()
    
    private final var FaceDetectorOptionsObj: FaceDetectorOptions?
    private final var FaceDetectorObj: FaceDetector?
    
    private final var BarcodeScannerOptionsObj: BarcodeScannerOptions?
    private final var BarcodeScannerObj: BarcodeScanner?
    
    // MARK: Internal Properties
    final weak var Delegate: HandleMLKitResponse?
    final var BarcodeFormat: BarcodeFormat = .all {
        didSet {
            InitializeBarcodeScanning()
        }
    }

    // ref https://developers.google.com/ml-kit/vision/barcode-scanning/ios
    // MARK: Barcode Scanning Methods
   final func BarcodeScanningUsingBufferRealtime(_ buffer: CMSampleBuffer) {
       if BarcodeScannerObj == nil {
           InitializeBarcodeScanning()
       }

       guard let barcodeScanner = BarcodeScannerObj else { return }

       let visionImage = VisionImage(buffer: buffer)
       visionImage.orientation = GetImageOrientation()

       do {
           let result = try barcodeScanner.results(in: visionImage)

           Delegate?.handleBarcodeScanningResult(result)
       } catch {
           "Realtime Barcode Scanning failed: \(error.localizedDescription)".log(.ProtectedError)
           return
       }
   }
    
   final func BarcodeScanningUsingBuffer(_ buffer: CMSampleBuffer, with orientation: UIImage.Orientation? = nil, completion: @escaping (Result<[Barcode], Error>) -> Void) {
       let visionImage = VisionImage(buffer: buffer)
       visionImage.orientation = orientation != nil ? orientation! : GetImageOrientation()

       ProcessBarcodeScanning(for: visionImage) { result in
           switch result {
               case .success(let barcodes):
                   completion(.success(barcodes))
                   self.Delegate?.handleBarcodeScanningResult(barcodes)
               case .failure(let error):
                   completion(.failure(error))
                   self.Delegate?.handleError(error)
           }
       }
   }
    
   final func BarcodeScanningUsingImage(_ image: UIImage, with orientation: UIImage.Orientation? = nil, completion: @escaping (Result<[Barcode], Error>) -> Void) {
       let visionImage = VisionImage(image: image)
       visionImage.orientation = orientation != nil ? orientation! : GetImageOrientation()

       ProcessBarcodeScanning(for: visionImage) { result in
           switch result {
               case .success(let barcodes):
                   completion(.success(barcodes))
                   self.Delegate?.handleBarcodeScanningResult(barcodes)
               case .failure(let error):
                   completion(.failure(error))
                   self.Delegate?.handleError(error)
           }
       }
   }
    
    // ref https://developers.google.com/ml-kit/vision/face-detection/ios
    // MARK: Face Detection Methods
    final func FaceDetectionUsingBufferRealtime(_ buffer: CMSampleBuffer) {
        if FaceDetectorObj == nil {
            InitializeFaceDetection()
        }
        
        guard let faceDetector = FaceDetectorObj else { return }
        
        let visionImage = VisionImage(buffer: buffer)
        visionImage.orientation = GetImageOrientation()
        
        do {
            let result = try faceDetector.results(in: visionImage)
            
            Delegate?.handleFaceDetectionResult(result)
        } catch {
            "Realtime Face Detection failed: \(error.localizedDescription)".log(.ProtectedError)
            return
        }
    }
    
    final func FaceDetectionUsingBuffer(_ buffer: CMSampleBuffer, with orientation: UIImage.Orientation? = nil, completion: @escaping (Result<[Face], Error>) -> Void) {
        let visionImage = VisionImage(buffer: buffer)
        visionImage.orientation = orientation != nil ? orientation! : GetImageOrientation()
        
        ProcessFaceDetection(for: visionImage) { result in
            switch result {
                case .success(let faces):
                    completion(.success(faces))
                    self.Delegate?.handleFaceDetectionResult(faces)
                case .failure(let error):
                    completion(.failure(error))
                    self.Delegate?.handleError(error)
            }
        }
    }
    
    final func FaceDetectionUsingImage(_ image: UIImage, with orientation: UIImage.Orientation? = nil, completion: @escaping (Result<[Face], Error>) -> Void) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = UIImage.Orientation.up
        //orientation != nil ? orientation! : GetImageOrientation()
        
        ProcessFaceDetection(for: visionImage) { result in
            switch result {
                case .success(let faces):
                    completion(.success(faces))
                    self.Delegate?.handleFaceDetectionResult(faces)
                case .failure(let error):
                    completion(.failure(error))
                    self.Delegate?.handleError(error)
            }
        }
    }
    
    // ref https://developers.google.com/ml-kit/vision/text-recognition/ios
    // MARK: Text Recognition Methods
//    final func TextRecognitionUsingBufferRealtime(_ buffer: CMSampleBuffer) {
//        let visionImage = VisionImage(buffer: buffer)
//        visionImage.orientation = GetImageOrientation()
//
//        do {
//            let result = try TextRecognizerObj.results(in: visionImage)
//
//            Delegate?.handleTextRecognitionResult(result)
//        } catch {
//            "Realtime Text Recognition failed: \(error.localizedDescription)".log(.ProtectedError)
//            return
//        }
//    }
    
    
//    final func TextRecognitionUsingBuffer(_ buffer: CMSampleBuffer, with orientation: UIImage.Orientation? = nil, completion: @escaping (Result<Text, Error>) -> Void) {
//        let visionImage = VisionImage(buffer: buffer)
//        visionImage.orientation = orientation != nil ? orientation! : GetImageOrientation()
//
//        ProcessTextRecognition(for: visionImage) { result in
//            switch result {
//                case .success(let text):
//                    completion(.success(text))
//                    self.Delegate?.handleTextRecognitionResult(text)
//                case .failure(let error):
//                    completion(.failure(error))
//                    self.Delegate?.handleError(error)
//            }
//        }
//    }
    
//    final func TextRecognitionUsingImage(_ image: UIImage, with orientation: UIImage.Orientation? = nil, completion: @escaping (Result<Text, Error>) -> Void) {
//        let visionImage = VisionImage(image: image)
//        visionImage.orientation = orientation != nil ? orientation! : GetImageOrientation()
//
//        ProcessTextRecognition(for: visionImage) { result in
//            switch result {
//                case .success(let text):
//                    completion(.success(text))
//                    self.Delegate?.handleTextRecognitionResult(text)
//                case .failure(let error):
//                    completion(.failure(error))
//                    self.Delegate?.handleError(error)
//            }
//        }
//    }
    
    // MARK: Private Process Methods
   private final func ProcessBarcodeScanning(for visionImage: VisionImage, completion: @escaping (Result<[Barcode], Error>) -> Void) {
       if BarcodeScannerObj == nil {
           InitializeBarcodeScanning()
       }

       guard let barcodeScanner = BarcodeScannerObj else { return }

       barcodeScanner.process(visionImage) { features, error in

           guard error == nil, let features = features else {
               guard let error = error else { return }

               completion(.failure(error))
               return
           }

           completion(.success(features))
       }
   }
    
    private final func ProcessFaceDetection(for visionImage: VisionImage, completion: @escaping (Result<[Face], Error>) -> Void) {
        if FaceDetectorObj == nil {
            InitializeFaceDetection()
        }
        
        guard let faceDetector = FaceDetectorObj else { return }
        
        faceDetector.process(visionImage) { faces, error in
            
            guard error == nil, let faces = faces else {
                guard let error = error else { return }
                
                completion(.failure(error))
                return
            }
            
            completion(.success(faces))
        }
    }
    
//    private final func ProcessTextRecognition(for visionImage: VisionImage, completion: @escaping (Result<Text, Error>) -> Void) {
//        TextRecognizerObj.process(visionImage) { result, error in
//            
//            guard error == nil, let result = result else {
//                guard let error = error else { return }
//                
//                completion(.failure(error))
//                return
//            }
//            
//            completion(.success(result))
//        }
//    }
//    
//    // MARK: Private Helper Methods
   private final func InitializeBarcodeScanning() {
       let barcodeScannerOptions = BarcodeScannerOptions(formats: BarcodeFormat)

       BarcodeScannerOptionsObj = barcodeScannerOptions
       
       BarcodeScannerObj = BarcodeScanner.barcodeScanner(options: barcodeScannerOptions)
   }
    
    private final func InitializeFaceDetection() {
        let faceDetectorOptions = FaceDetectorOptions()
        faceDetectorOptions.performanceMode = .accurate
        faceDetectorOptions.landmarkMode = .all
        faceDetectorOptions.contourMode = .none
        faceDetectorOptions.classificationMode = .none
        faceDetectorOptions.minFaceSize = 0.1
        faceDetectorOptions.isTrackingEnabled = false
        
        FaceDetectorOptionsObj = faceDetectorOptions
        
        FaceDetectorObj = FaceDetector.faceDetector(options: faceDetectorOptions)
    }
    
    private final func GetImageOrientation() -> UIImage.Orientation {
        guard let configCameraPosition = SybrinIdentity.shared.configuration?.cameraPosition else { return .left }
        
        return configCameraPosition == .front ? .right : .left
    }
    
}
