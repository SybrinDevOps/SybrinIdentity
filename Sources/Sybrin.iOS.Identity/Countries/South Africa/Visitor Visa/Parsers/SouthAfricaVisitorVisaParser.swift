////
////  SouthAfricaVisitorVisaParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Armand Riley on 2021/09/02.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
////import MLKit
//
//struct SouthAfricaVisitorVisaParser {
//    
//    // MARK: Private Properties
//    // Parser
//    private let Parser = BaseSouthAfricaVisaParser(title: "Visitors Visa")
//    
//    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: SouthAfricaVisitorVisaModel) -> Void) {
//        Parser.ParseText(from: result)
//        
//        if Parser.IsAllParsed, let model = BaseSouthAfricaVisaModelToSouthAfricaVisitorVisaModel(Parser.Model) {
//            success(model)
//            Reset()
//        }
//    }
//    
//    // MARK: Private Methods
//    private func Reset() {
//        Parser.Reset()
//    }
//    
//    private func BaseSouthAfricaVisaModelToSouthAfricaVisitorVisaModel(_ baseSouthAfricaVisaModel: BaseSouthAfricaVisaModel) -> SouthAfricaVisitorVisaModel? {
//        let model = SouthAfricaVisitorVisaModel()
//        
//        model.Names = baseSouthAfricaVisaModel.Names
//        model.PassportNumber = baseSouthAfricaVisaModel.PassportNumber
//        model.NumberOfEntries = baseSouthAfricaVisaModel.NumberOfEntries
//        model.ValidFrom = baseSouthAfricaVisaModel.ValidFrom
//        model.ReferenceNumber = baseSouthAfricaVisaModel.ReferenceNumber
//        model.DateOfExpiry = baseSouthAfricaVisaModel.DateOfExpiry
//        model.IssuedAt = baseSouthAfricaVisaModel.IssuedAt
//        model.ControlNumber = baseSouthAfricaVisaModel.ControlNumber
//        model.BarcodeData = baseSouthAfricaVisaModel.BarcodeData
//        
//        return model
//    }
//    
//}
