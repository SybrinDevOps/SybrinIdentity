////
////  SouthAfricaGeneralWorkVisaParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Armand Riley on 2021/09/03.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
////import MLKit
//
//struct SouthAfricaGeneralWorkVisaParser {
//    
//    // MARK: Private Properties
//    // Parser
//    private let Parser = SouthAfricaBaseGeneralWorkVisaParser(title: "General Work Visa")
//    
//    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: SouthAfricaGeneralWorkVisaModel) -> Void) {
//        Parser.ParseText(from: result)
//        
//        if Parser.IsAllParsed, let model = BaseSouthAfricaVisaModelToSouthAfricaGeneralWorkVisaModel(Parser.Model) {
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
//    private func BaseSouthAfricaVisaModelToSouthAfricaGeneralWorkVisaModel(_ baseSouthAfricaVisaModel: BaseSouthAfricaVisaModel) -> SouthAfricaGeneralWorkVisaModel? {
//        let model = SouthAfricaGeneralWorkVisaModel()
//        
//        model.Names = baseSouthAfricaVisaModel.Names
//        model.PassportNumber = baseSouthAfricaVisaModel.PassportNumber
//        model.NumberOfEntries = baseSouthAfricaVisaModel.NumberOfEntries
//        model.On = baseSouthAfricaVisaModel.ValidFrom
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
