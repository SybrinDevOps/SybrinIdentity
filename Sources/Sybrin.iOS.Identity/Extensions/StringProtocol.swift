//
//  StringProtocol.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/28.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

extension StringProtocol {
    
    func replaceCommonCharactersWithNumbers() -> String {
        return self
            .replacingOccurrences(of: "i", with: "1")
            .replacingOccurrences(of: "I", with: "1")
            .replacingOccurrences(of: "l", with: "1")
            .replacingOccurrences(of: "o", with: "0")
            .replacingOccurrences(of: "O", with: "0")
            .replacingOccurrences(of: "Q", with: "0")
            .replacingOccurrences(of: "q", with: "9")
            .replacingOccurrences(of: "S", with: "5")
            .replacingOccurrences(of: "s", with: "5")
            .replacingOccurrences(of: "D", with: "0")
            .replacingOccurrences(of: "B", with: "8")
            .replacingOccurrences(of: "b", with: "6")
            .replacingOccurrences(of: "z", with: "7")
            .replacingOccurrences(of: "Z", with: "7")
            .replacingOccurrences(of: "&", with: "8")
    }
    
    func replaceCommonCharactersWithLetters() -> String {
        return self
            .replacingOccurrences(of: "0", with: "O")
            .replacingOccurrences(of: "1", with: "l")
            .replacingOccurrences(of: "4", with: "A")
            .replacingOccurrences(of: "5", with: "S")
            .replacingOccurrences(of: "6", with: "b")
            .replacingOccurrences(of: "8", with: "B")
            .replacingOccurrences(of: "9", with: "q")
            .replacingOccurrences(of: "&", with: "B")
    }
    
    func replaceCommonLettersAndNumbersWithCharacters() -> String {
        return self
            .replacingOccurrences(of: "4", with: "+")
    }
    
}
