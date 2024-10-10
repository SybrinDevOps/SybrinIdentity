//
//  GenericIDCardParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/20.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
////import MLKit
import Foundation

struct GenericIDCardParser {
    
    // MARK: Private Properties
    
    // Resetting Model
    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private let ResetEveryMilliseconds: Double = 10000
    
    // MARK: Internal Methods
//    mutating func ParseFront(from result: Text, success: @escaping (_ model: GenericIDCardModel) -> Void) {
//        resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//
//            Reset()
//        }
//        
//        let model: GenericIDCardModel = GenericIDCardModel()
//        model.FrontResult = result.text
//        
//        if !model.FrontResult!.isEmpty{
//            success(model)
//            Reset()
//        }
//        
//    }
//    
//    mutating func ParseBack(from result: Text, success: @escaping (_ model: GenericIDCardModel) -> Void) {
//        resetCheck: if ResetEveryMilliseconds >= 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//            PreviousResetTime = currentTimeMs
//
//            Reset()
//        }
//        
//        let model: GenericIDCardModel = GenericIDCardModel()
//        model.BackResult = result.text
//        
//        if !model.BackResult!.isEmpty{
//            success(model)
//            Reset()
//        }
//        
//    }
    
    // MARK: Private Methods
    private func Reset() {
    }
}
