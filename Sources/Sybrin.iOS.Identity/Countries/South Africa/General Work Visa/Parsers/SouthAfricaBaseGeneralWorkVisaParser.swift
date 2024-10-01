//
//  SouthAfricaBaseGeneralWorkVisaParser.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/09/03.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
class SouthAfricaBaseGeneralWorkVisaParser: BaseSouthAfricaVisaParser{
    
    // Finding On (Valid From)
    override func parseValidFrom(from sybrinItemGroup: SybrinItemGroup) {
        if !ValidFromParsed {
            let potentialMatches = sybrinItemGroup.Lines.filter { item in
                let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
                return (itemText.contains("on"))
            }.flatMap { $0.Elements }
            
            search: for potentialMatch in potentialMatches {
                
                let bagOfWords = ["On": "","on": "","ON": "", ": ": "", "; ": "" , ". " : "" , "," : ""]
                var cleanedPotentialMatch: String = bagOfWords.reduce(potentialMatch.Text) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
                
                cleanedPotentialMatch = cleanedPotentialMatch.trimmingCharacters(in: .whitespacesAndNewlines).replaceCommonCharactersWithNumbers().replacingOccurrences(of: "-", with: "")
                
                guard cleanedPotentialMatch.count == 8 else { continue search }
                
                guard let validFrom = cleanedPotentialMatch.stringToDate(withFormat: "yyyyMMdd") else { continue search }
                
                ValidFromParsed = true
                Model.ValidFrom = validFrom
                break search
            }
        }
    }
}
