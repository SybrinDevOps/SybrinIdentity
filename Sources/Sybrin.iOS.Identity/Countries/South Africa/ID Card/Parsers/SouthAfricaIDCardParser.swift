//
//  SouthAfricaIDCardParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

////import MLKit
//
//struct SouthAfricaIDCardParser {
//    
//    // MARK: Internal Methods
//    func ParseFront(from result: Text, success: @escaping (_ model: SouthAfricaIDCardModel) -> Void) {
//        let model = SouthAfricaIDCardModel()
//        
//        let resultText = result.text.lowercased().replaceCommonCharactersWithLetters()
//        guard resultText.contains("national") && resultText.contains("identity") && resultText.contains("card") else { return }
//        
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                let lineText = line.text.lowercased().replaceCommonCharactersWithNumbers()
//                if lineText.count != 13 {
//                    continue inner
//                }
//                if (RegexConstants.SouthAfrica_IdentityNumber.matches(lineText)), let identityNumber = SouthAfricaIdentityNumberParser.ParseIdentityNumber(lineText)?.IdentityNumber {
//                    model.IdentityNumber = identityNumber
//                    success(model)
//                    break outer
//                }
//            }
//        }
//    }
//    
//    func ParseBack(from result: Barcode, success: @escaping (_ model: SouthAfricaIDCardModel) -> Void) {
//        
//        if let barcodeResult = result.displayValue {
//            if let model = ParseBarcode(barcodeResult) {
//                success(model)
//            }
//            
////            let model = ParseBarcode(barcodeResult)!
////            success(model)
//        }
//    }
//    
//    // MARK: Private Methods
//    private func ParseBarcode(_ barcodeResult: String) -> SouthAfricaIDCardModel? {
//        let model = SouthAfricaIDCardModel()
//        
//        let barcodeResultArray = barcodeResult.components(separatedBy: "|")
//        
//        if barcodeResultArray.count == 12 {
//            
//            // Parsing Surname / barcodeResultArray[0]
//            model.Surname = barcodeResultArray[0]
//            
//            // Parsing Names / barcodeResultArray[1]
//            model.Names = barcodeResultArray[1]
//            
//            // Parsing Gender / barcodeResultArray[2]
//            model.Sex = barcodeResultArray[2] == "M" ? Sex(rawValue: 0) : Sex(rawValue: 1)
//            
//            // Parsing Nationality / barcodeResultArray[3]
//            model.Nationality = barcodeResultArray[3]
//            
//            // Parsing Identity Number / barcodeResultArray[4]
//            guard let identityNumber = SouthAfricaIdentityNumberParser.ParseIdentityNumber(barcodeResultArray[4])?.IdentityNumber else { return nil }
//            
//            model.IdentityNumber = identityNumber
//            
//            // Parsing Date Of Birth / barcodeResultArray[5]
//            guard barcodeResultArray[5].count == 11 else { return nil }
//            
//            model.DateOfBirth = barcodeResultArray[5].stringToDate(withFormat: "dd MMM yyyy")
//            
//            
//            guard model.DateOfBirth != nil else { return nil }
//            
//            // Parsing Country Of Birth / barcodeResultArray[6]
//            model.CountryOfBirth = barcodeResultArray[6]
//            
//            // Parsing Citizenship / barcodeResultArray[7]
//            if  barcodeResultArray[7].lowercased() == "citizen" {
//                model.Citizenship = .Citizen
//            } else if barcodeResultArray[7].lowercased() == "permanentresident" {
//                model.Citizenship = .PermanentResident
//            }
//            
//            guard model.Citizenship != nil else { return nil }
//            
//            // Parsing Date Issued / barcodeResultArray[8]
//            guard barcodeResultArray[8].count == 11 else { return nil }
//            
//            
//            model.DateIssued = barcodeResultArray[8].stringToDate(withFormat: "dd MMM yyyy")
//            
//            
//            if barcodeResultArray[8].stringToDate(withFormat: "dd MMM yyyy") == nil {
//                
//                var dateComponents = DateComponents()
//                dateComponents.year = 1980
//                dateComponents.month = 7
//                dateComponents.day = 11
//                dateComponents.timeZone = TimeZone(abbreviation: "JST")
//                dateComponents.hour = 8
//                dateComponents.minute = 34
//
//                // Create date from components
//                let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
//                let someDateTime = userCalendar.date(from: dateComponents)
//                
//                model.DateIssued = someDateTime
//                
//            }
//            
//            // Parsing RSA Code / barcodeResultArray[9]
//            model.RSACode = barcodeResultArray[9]
//            
//            // Parsing Card Number / barcodeResultArray[10]
//            model.CardNumber = barcodeResultArray[10]
//            
//        } else { return nil }
//        
//        guard model.Surname != nil else { return nil }
//        
//        guard model.Names != nil else { return nil }
//        
//        guard model.Sex != nil else { return nil }
//        
//        guard model.Nationality != nil else { return nil }
//        
//        guard model.CountryOfBirth != nil else { return nil }
//        
//        guard model.RSACode != nil else { return nil }
//        
//        guard model.CardNumber != nil else { return nil }
//        
//        return model
//    }
//    
//}
