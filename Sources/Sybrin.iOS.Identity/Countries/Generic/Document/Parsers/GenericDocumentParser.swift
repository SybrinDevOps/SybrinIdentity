//
//  GenericDocumentParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/17.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
//import MLKitVision 
import Foundation

struct GenericDocumentParser {
    
    // MARK: Private Properties
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: GenericDocumentModel) -> Void) {
//        resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//
//            Reset()
//        }
//        
//        let model: GenericDocumentModel = GenericDocumentModel()
//        model.Result = result.text
//        
//        if !model.Result!.isEmpty{
//            success(model)
//            Reset()
//        }
//        
//    }
    
    // MARK: Private Methods
    private func Reset() {
    }
}
