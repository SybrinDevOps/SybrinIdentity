////
////  SouthAfricaStudyVisaParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Armand Riley on 2021/10/27.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
//
////import MLKit
//
//struct SouthAfricaStudyVisaParser {
//    
//    // MARK: Private Properties
//    // Parser
//    private let Parser = SouthAfricaBaseStudyVisaParser(title: "Study Visa")
//    
//    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: SouthAfricaStudyVisaModel) -> Void) {
//        Parser.ParseText(from: result)
//        
//        if Parser.IsAllParsed, let model = BaseSouthAfricaVisaModelToSouthAfricaStudyVisaModel(Parser.Model) {
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
//    private func BaseSouthAfricaVisaModelToSouthAfricaStudyVisaModel(_ baseSouthAfricaVisaModel: BaseSouthAfricaVisaModel) -> SouthAfricaStudyVisaModel? {
//        let model = SouthAfricaStudyVisaModel()
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
