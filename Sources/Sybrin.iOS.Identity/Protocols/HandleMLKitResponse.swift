//
//  HandleMLKitResponse.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/24.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import MLKitFaceDetection
import MLKitBarcodeScanning

protocol HandleMLKitResponse: AnyObject {
    func handleFaceDetectionResult(_ result: [Face])
    func handleBarcodeScanningResult(_ result: [Barcode])
    func handleError(_ error: Error)
}

extension HandleMLKitResponse {
    func handleFaceDetectionResult(_ result: [Face]) { }
    func handleBarcodeScanningResult(_ result: [Barcode]) { }
}
