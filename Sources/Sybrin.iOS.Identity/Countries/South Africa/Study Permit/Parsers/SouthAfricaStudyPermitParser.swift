////
////  SouthAfricaStudyPermitParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Armand Riley on 2021/09/03.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
////import MLKit
//
//struct SouthAfricaStudyPermitParser {
//    
//    // MARK: Private Properties
//    // Parser
//    private let Parser = SouthAfricaBaseStudentPermitParser(title: "Study Permit")
//    
//    // MARK: Internal Methods
//    mutating func Parse(from result: Text, success: @escaping (_ model: SouthAfricaStudyPermitModel) -> Void) {
//        Parser.ParseText(from: result)
//        
//        if Parser.IsAllParsed, let model = BaseSouthAfricaVisaModelToSouthAfricaStudyPermitModel(Parser.Model) {
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
//    private func BaseSouthAfricaVisaModelToSouthAfricaStudyPermitModel(_ baseSouthAfricaVisaModel: BaseSouthAfricaVisaModel) -> SouthAfricaStudyPermitModel? {
//        let model = SouthAfricaStudyPermitModel()
//        
//        model.Names = baseSouthAfricaVisaModel.Names
//        model.PassportNumber = baseSouthAfricaVisaModel.PassportNumber
//        model.NumberOfEntries = baseSouthAfricaVisaModel.NumberOfEntries
//        model.ValidFrom = baseSouthAfricaVisaModel.ValidFrom
//        model.DateOfExpiry = baseSouthAfricaVisaModel.DateOfExpiry
//        model.IssuedAt = baseSouthAfricaVisaModel.IssuedAt
//        model.ControlNumber = baseSouthAfricaVisaModel.ControlNumber
//        model.BarcodeData = baseSouthAfricaVisaModel.BarcodeData
//        
//        return model
//    }
//    
//}
