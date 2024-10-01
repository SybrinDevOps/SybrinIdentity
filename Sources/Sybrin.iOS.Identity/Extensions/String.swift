//
//  String.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/05/03.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

extension String {
    
    func addWordToSentence(word: String) -> String {
        return self + ((self.count > 0 && RegexConstants.AlphaNumeric.matches(word)) ? " " : "") + word
    }
    
    /// Searches for the first occurance of `"<<<"` and the last occurance of `"<"` and then, if found, replaces all of the characters in between with multiple `"<"` of equal length.
    ///
    /// This is to fix an OCR issue where multiple subsequent `"<"` could sometimes cause weird characters to occur in between. Example:` "<<««<K<<KK<c<e<<"`.
    ///
    /// This method also replaces all non alphanumeric characters (excluding `"<"`) with `"<"`
    func fixMRZGarbage(completeLength: Int? = nil) -> String {
        var newLine = self.replacingOccurrences(of: RegexConstants.MRZAccepted.pattern, with: "<", options: .regularExpression)
        
        let startOfBrokenness = newLine.indexOf(str: "<<<") ?? -1
        let endOfBrokenness = newLine.count - (String(newLine.reversed()).indexOf(str: "<") ?? newLine.count + 1)
        
        if startOfBrokenness > -1 {
            if let completeLength = completeLength, completeLength > -1 && (endOfBrokenness == -1 || endOfBrokenness == self.count - 1), completeLength > startOfBrokenness {
                newLine = String(
                    newLine.substring(to: startOfBrokenness) + // Copies the first original part of the string that is not broken
                    String(repeating: "<", count: completeLength - startOfBrokenness) // Replaces the broken parts with '<' for the desired string length
                )
            }
            else if endOfBrokenness > -1 && endOfBrokenness > startOfBrokenness {
                newLine = String(
                    newLine.substring(to: startOfBrokenness) + // Copies the first original part of the string that is not broken
                    String(repeating: "<", count: endOfBrokenness - startOfBrokenness) + // Replaces the broken parts in between with '<'
                    newLine.substring(from: endOfBrokenness) // Adds the rest of the string back
                )
            }
        }
        
        return newLine
    }
    
}
