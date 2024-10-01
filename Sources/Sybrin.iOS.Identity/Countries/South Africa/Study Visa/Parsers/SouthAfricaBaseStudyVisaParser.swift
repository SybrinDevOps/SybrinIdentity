//
//  SouthAfricaBaseStudyVisaParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/10/27.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Foundation

class SouthAfricaBaseStudyVisaParser: BaseSouthAfricaVisaParser{
    
    override func parseReferenceNumber(from sybrinItemGroup: SybrinItemGroup){
        if !ReferenceNumberParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("refno"))
            }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["Ref": "","ref": "","REF": "", ": ": "", "; ": "" , ". " : "" , "," : "", "No": "" , "no": "" , "NO": "", "Na": "" , "na": "" , "NA": "",]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard cleanedPotentialMatch.count == 19 else { continue search }
                
                guard RegexConstants.SouthAfrica_Visa_Reference_Number.matches(cleanedPotentialMatch) else { continue search }
                
                ReferenceNumberParsed = true
                Model.ReferenceNumber = cleanedPotentialMatch
                break search
            }
        }
    }
}
