//
//  SouthAfricaBaseVisaParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/03.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

class SouthAfricaBaseStudentPermitParser: BaseSouthAfricaVisaParser{
    
    // Finding Issued At & Valid From
    override func parseIssuedAt(from sybrinItemGroup: SybrinItemGroup) {
        if !IssuedAtParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("issuedat"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Issued": "","issued": "","ISSUED": "", ": ": "", "; ": "" , ". " : "" , "," : "" , "At": "" , "at": "" , "AT": ""]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.replaceCommonCharactersWithLetters().trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard cleanedPotentialMatch.count >= 3 && cleanedPotentialMatch.count <= 40 else { continue search }
                
                guard RegexConstants.NoNumbers.matches(cleanedPotentialMatch) else { continue search }
                
                if !ValidFromParsed {
                    let issuedAtArray: [String] = cleanedPotentialMatch.components(separatedBy: " on ")
                    
                    // Finding Issued At
                    let potentialIssuedAt: String = issuedAtArray[0]
                    
                    guard potentialIssuedAt.count >= 3 && potentialIssuedAt.count <= 40 else { continue search }
                    
                    IssuedAtParsed = true
                    Model.IssuedAt = potentialIssuedAt
                    
                    // Finding Valid From
                    var potentialValidFrom: String = issuedAtArray[1]
                    potentialValidFrom = potentialValidFrom.trimmingCharacters(in: .whitespacesAndNewlines).replaceCommonCharactersWithNumbers().replacingOccurrences(of: ".", with: "")
                    
                    guard potentialValidFrom.count == 8 else { continue search }
                    
                    guard let validFrom = potentialValidFrom.stringToDate(withFormat: "yyyyMMdd") else { continue search }
                    
                    ValidFromParsed = true
                    Model.ValidFrom = validFrom
                    break search
                }
            }
        }
    }
    
    override func parseValidFrom(from sybrinItemGroup: SybrinItemGroup) {
        // Disable functionality
    }
    
    // Skipping Reference Number Check
    override func parseReferenceNumber(from sybrinItemGroup: SybrinItemGroup) {
        ReferenceNumberParsed = true;
    }
    
}
